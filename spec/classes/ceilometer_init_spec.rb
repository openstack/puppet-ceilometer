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

    context 'with amqp messaging' do
      it_configures 'amqp support'
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
      is_expected.to contain_ceilometer_config('publisher/telemetry_secret').with_value('metering-s3cr3t')
      is_expected.to contain_ceilometer_config('publisher/telemetry_secret').with_value( params[:telemetry_secret] ).with_secret(true)
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
        :topics        => ['notifications']
      )
    end

    it 'configures snmpd auth' do
      is_expected.to contain_ceilometer_config('hardware/readonly_user_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('hardware/readonly_user_password').with_value('<SERVICE DEFAULT>').with_secret(true)
    end

    it 'configures cache backend' do
      is_expected.to contain_oslo__cache('ceilometer_config').with(
        :backend                   => '<SERVICE DEFAULT>',
        :memcache_servers          => '<SERVICE DEFAULT>',
        :enable_socket_keepalive   => '<SERVICE DEFAULT>',
        :socket_keepalive_idle     => '<SERVICE DEFAULT>',
        :socket_keepalive_interval => '<SERVICE DEFAULT>',
        :socket_keepalive_count    => '<SERVICE DEFAULT>',
        :tls_enabled               => '<SERVICE DEFAULT>',
        :tls_cafile                => '<SERVICE DEFAULT>',
        :tls_certfile              => '<SERVICE DEFAULT>',
        :tls_keyfile               => '<SERVICE DEFAULT>',
        :tls_allowed_ciphers       => '<SERVICE DEFAULT>',
        :enable_retry_client       => '<SERVICE DEFAULT>',
        :retry_attempts            => '<SERVICE DEFAULT>',
        :retry_delay               => '<SERVICE DEFAULT>',
        :hashclient_retry_attempts => '<SERVICE DEFAULT>',
        :hashclient_retry_delay    => '<SERVICE DEFAULT>',
        :dead_timeout              => '<SERVICE DEFAULT>',
        :manage_backend_package    => true,
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

    context 'with overridden cache parameter' do
      before {
        params.merge!(
          :cache_backend                   => 'memcache',
          :memcache_servers                => 'host1:11211,host2:11211',
          :cache_enable_socket_keepalive   => false,
          :cache_socket_keepalive_idle     => 1,
          :cache_socket_keepalive_interval => 1,
          :cache_socket_keepalive_count    => 1,
          :cache_tls_enabled               => true,
          :cache_enable_retry_client       => false,
          :cache_retry_attempts            => 2,
          :cache_retry_delay               => 0,
          :cache_hashclient_retry_attempts => 2,
          :cache_hashclient_retry_delay    => 1,
          :cache_dead_timeout              => 60,
          :manage_backend_package          => false,
        )
      }

      it 'configures cache backend' do
        is_expected.to contain_oslo__cache('ceilometer_config').with(
          :backend                   => 'memcache',
          :memcache_servers          => 'host1:11211,host2:11211',
          :enable_socket_keepalive   => false,
          :socket_keepalive_idle     => 1,
          :socket_keepalive_interval => 1,
          :socket_keepalive_count    => 1,
          :tls_enabled               => true,
          :enable_retry_client       => false,
          :retry_attempts            => 2,
          :retry_delay               => 0,
          :hashclient_retry_attempts => 2,
          :hashclient_retry_delay    => 1,
          :dead_timeout              => 60,
          :manage_backend_package    => false,
        )
      end
    end

    context 'with overridden notification parameters' do
      before {
        params.merge!(
          :notification_topics        => ['notifications', 'custom'],
          :notification_driver        => 'messagingv2',
          :notification_transport_url => 'rabbit://rabbit_user:password@localhost:5673',
        )
      }

      it 'configures notifications' do
        is_expected.to contain_oslo__messaging__notifications('ceilometer_config').with(
          :transport_url => 'rabbit://rabbit_user:password@localhost:5673',
          :driver        => 'messagingv2',
          :topics        => ['notifications', 'custom']
        )
      end
    end
  end

  shared_examples_for 'rabbit without HA support' do

    it 'configures rabbit' do
      is_expected.to contain_oslo__messaging__rabbit('ceilometer_config').with(
        :rabbit_ha_queues            => '<SERVICE DEFAULT>',
        :heartbeat_timeout_threshold => '<SERVICE DEFAULT>',
        :heartbeat_rate              => '<SERVICE DEFAULT>',
        :heartbeat_in_pthread        => '<SERVICE DEFAULT>',
        :rabbit_qos_prefetch_count   => '<SERVICE DEFAULT>',
        :amqp_durable_queues         => '<SERVICE DEFAULT>',
        :kombu_reconnect_delay       => '<SERVICE DEFAULT>',
        :kombu_failover_strategy     => '<SERVICE DEFAULT>',
        :kombu_compression          => '<SERVICE DEFAULT>',
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

  shared_examples_for 'amqp support' do
    context 'with default parameters' do
      it { is_expected.to contain_oslo__messaging__amqp('ceilometer_config').with(
        :server_request_prefix => '<SERVICE DEFAULT>',
        :broadcast_prefix      => '<SERVICE DEFAULT>',
        :group_request_prefix  => '<SERVICE DEFAULT>',
        :container_name        => '<SERVICE DEFAULT>',
        :idle_timeout          => '<SERVICE DEFAULT>',
        :trace                 => '<SERVICE DEFAULT>',
        :ssl_ca_file           => '<SERVICE DEFAULT>',
        :ssl_cert_file         => '<SERVICE DEFAULT>',
        :ssl_key_file          => '<SERVICE DEFAULT>',
        :sasl_mechanisms       => '<SERVICE DEFAULT>',
        :sasl_config_dir       => '<SERVICE DEFAULT>',
        :sasl_config_name      => '<SERVICE DEFAULT>',
        :username              => '<SERVICE DEFAULT>',
        :password              => '<SERVICE DEFAULT>',
      ) }
    end

    context 'with overridden amqp parameters' do
      before { params.merge!(
        :amqp_idle_timeout  => '60',
        :amqp_trace         => true,
        :amqp_ssl_ca_file   => '/path/to/ca.cert',
        :amqp_ssl_cert_file => '/path/to/certfile',
        :amqp_ssl_key_file  => '/path/to/key',
        :amqp_username      => 'amqp_user',
        :amqp_password      => 'password',
      ) }

      it { is_expected.to contain_oslo__messaging__amqp('ceilometer_config').with(
        :server_request_prefix => '<SERVICE DEFAULT>',
        :broadcast_prefix      => '<SERVICE DEFAULT>',
        :group_request_prefix  => '<SERVICE DEFAULT>',
        :container_name        => '<SERVICE DEFAULT>',
        :idle_timeout          => '60',
        :trace                 => true,
        :ssl_ca_file           => '/path/to/ca.cert',
        :ssl_cert_file         => '/path/to/certfile',
        :ssl_key_file          => '/path/to/key',
        :sasl_mechanisms       => '<SERVICE DEFAULT>',
        :sasl_config_dir       => '<SERVICE DEFAULT>',
        :sasl_config_name      => '<SERVICE DEFAULT>',
        :username              => 'amqp_user',
        :password              => 'password',
      ) }
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
        case facts[:osfamily]
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
