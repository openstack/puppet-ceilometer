require 'spec_helper'

describe 'ceilometer' do

  let :params do
    {
      :http_timeout          => '600',
      :max_parallel_requests => 64,
      :telemetry_secret      => 'metering-s3cr3t',
      :package_ensure        => 'present',
      :purge_config          => false,
      :host                  => 'foo.domain'
    }
  end

  shared_examples_for 'ceilometer' do

    it 'configures timeout for HTTP requests' do
      is_expected.to contain_ceilometer_config('DEFAULT/http_timeout').with_value(params[:http_timeout])
    end

    it 'configures max_parallel_requests' do
      is_expected.to contain_ceilometer_config('DEFAULT/max_parallel_requests').with_value(params[:max_parallel_requests])
    end

    it 'configures host name' do
      is_expected.to contain_ceilometer_config('DEFAULT/host').with_value(params[:host])
    end

    context 'with rabbit parameters' do
      it_configures 'a ceilometer base installation'
      it_configures 'rabbit with SSL support'
      it_configures 'rabbit without HA support'
      it_configures 'rabbit with connection heartbeats'

      context 'with rabbit_ha_queues' do
        before { params.merge!( :rabbit_ha_queues => true ) }
        it_configures 'rabbit with rabbit_ha_queues'
       end

    end

    context 'with rabbit parameters' do
      context 'with one server' do
        it_configures 'a ceilometer base installation'
        it_configures 'rabbit with SSL support'
        it_configures 'rabbit without HA support'
      end
    end
  end

  shared_examples_for 'a ceilometer base installation' do

    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs ceilometer common package' do
      is_expected.to contain_package('ceilometer-common').with(
        :ensure => 'present',
        :name   => platform_params[:common_package_name],
        :tag    => ['openstack', 'ceilometer-package'],
      )
    end

    it 'passes purge to resource' do
      is_expected.to contain_resources('ceilometer_config').with({
        :purge => false
      })
    end

    it 'configures required telemetry_secret' do
      is_expected.to contain_ceilometer_config('publisher/telemetry_secret').with_value(params[:telemetry_secret]).with_secret(true)
    end

    context 'without the required telemetry_secret' do
      before { params.delete(:telemetry_secret) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it 'configures default transport_url' do
      is_expected.to contain_oslo__messaging__default('ceilometer_config').with(
        :executor_thread_pool_size => '<SERVICE DEFAULT>',
        :transport_url             => '<SERVICE DEFAULT>',
        :rpc_response_timeout      => '<SERVICE DEFAULT>',
        :control_exchange          => '<SERVICE DEFAULT>'
      )
    end

    it 'configures notifications' do
      is_expected.to contain_oslo__messaging__notifications('ceilometer_config').with(
        :transport_url => '<SERVICE DEFAULT>',
        :driver        => '<SERVICE DEFAULT>',
        :topics        => '<SERVICE DEFAULT>',
        :retry         => '<SERVICE DEFAULT>',
      )
    end

    context 'with rabbitmq durable queues configured' do
      before { params.merge!( :amqp_durable_queues => true ) }
      it_configures 'rabbit with durable queues'
    end

    context 'with overridden transport_url parameter' do
      before {
        params.merge!(
          :executor_thread_pool_size => '128',
          :default_transport_url     => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout      => '120',
          :control_exchange          => 'ceilometer',
        )
      }

      it 'configures transport_url' do
        is_expected.to contain_oslo__messaging__default('ceilometer_config').with(
          :executor_thread_pool_size => '128',
          :transport_url             => 'rabbit://rabbit_user:password@localhost:5673',
          :rpc_response_timeout      => '120',
          :control_exchange          => 'ceilometer'
        )
      end
    end

    context 'with overridden notification parameters' do
      before {
        params.merge!(
          :notification_topics        => ['notifications', 'custom'],
          :notification_driver        => 'messagingv2',
          :notification_transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :notification_retry         => 10,
        )
      }

      it 'configures notifications' do
        is_expected.to contain_oslo__messaging__notifications('ceilometer_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'messagingv2',
          :topics        => ['notifications', 'custom'],
          :retry         => 10,
        )
      end
    end
  end

  shared_examples_for 'rabbit without HA support' do

    it 'configures rabbit' do
      is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
        :rabbit_ha_queues                => '<SERVICE DEFAULT>',
        :heartbeat_timeout_threshold     => '<SERVICE DEFAULT>',
        :heartbeat_rate                  => '<SERVICE DEFAULT>',
        :heartbeat_in_pthread            => '<SERVICE DEFAULT>',
        :rabbit_qos_prefetch_count       => '<SERVICE DEFAULT>',
        :amqp_durable_queues             => '<SERVICE DEFAULT>',
        :kombu_reconnect_delay           => '<SERVICE DEFAULT>',
        :kombu_failover_strategy         => '<SERVICE DEFAULT>',
        :kombu_compression               => '<SERVICE DEFAULT>',
        :rabbit_quorum_queue             => '<SERVICE DEFAULT>',
        :rabbit_transient_quorum_queue   => '<SERVICE DEFAULT>',
        :rabbit_quorum_delivery_limit    => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_length => '<SERVICE DEFAULT>',
        :rabbit_quorum_max_memory_bytes  => '<SERVICE DEFAULT>',
        :enable_cancel_on_failover       => '<SERVICE DEFAULT>',
      )
    end

  end

  shared_examples_for 'rabbit with rabbit_ha_queues' do

    it 'configures rabbit' do
      is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
        :rabbit_ha_queues => params[:rabbit_ha_queues]
      )
    end
  end

  shared_examples_for 'rabbit with durable queues' do
    it 'in ceilometer' do
      is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
        :amqp_durable_queues => params[:amqp_durable_queues]
      )
    end
  end

  shared_examples_for 'rabbit with connection heartbeats' do
    context "with heartbeat configuration" do
      before { params.merge!(
        :rabbit_heartbeat_timeout_threshold => '60',
        :rabbit_heartbeat_rate              => '10',
        :rabbit_heartbeat_in_pthread        => true,
      ) }

      it { is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
        :heartbeat_timeout_threshold => '60',
        :heartbeat_rate              => '10',
        :heartbeat_in_pthread        => true,
      ) }
    end
  end

  shared_examples_for 'rabbit with SSL support' do
    context "with default parameters" do
    it { is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
      :rabbit_use_ssl     => '<SERVICE DEFAULT>',
      :kombu_ssl_ca_certs => '<SERVICE DEFAULT>',
      :kombu_ssl_certfile => '<SERVICE DEFAULT>',
      :kombu_ssl_keyfile  => '<SERVICE DEFAULT>',
      :kombu_ssl_version  => '<SERVICE DEFAULT>',
    )}
    end

    context "with SSL enabled with kombu" do
      before { params.merge!(
        :rabbit_use_ssl     => true,
        :kombu_ssl_ca_certs => '/path/to/ca.crt',
        :kombu_ssl_certfile => '/path/to/cert.crt',
        :kombu_ssl_keyfile  => '/path/to/cert.key',
        :kombu_ssl_version  => 'TLSv1'
      ) }

    it { is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
      :rabbit_use_ssl     => true,
      :kombu_ssl_ca_certs => '/path/to/ca.crt',
      :kombu_ssl_certfile => '/path/to/cert.crt',
      :kombu_ssl_keyfile  => '/path/to/cert.key',
      :kombu_ssl_version  => 'TLSv1'
    )}
    end

    context "with SSL enabled without kombu" do
      before { params.merge!(
        :rabbit_use_ssl  => true
      ) }

    it { is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
      :rabbit_use_ssl     => true,
    )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
        case facts[:os]['family']
        when 'Debian'
          { :common_package_name => 'ceilometer-common' }
        when 'RedHat'
          { :common_package_name => 'openstack-ceilometer-common' }
        end
      end

      it_behaves_like 'ceilometer'
    end
  end

end
