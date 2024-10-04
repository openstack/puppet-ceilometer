require 'spec_helper'

describe 'ceilometer::agent::polling' do

  let :pre_condition do
    "include nova
    include nova::compute
    class { 'ceilometer': telemetry_secret => 's3cr3t' }"
  end

  let :params do
    {}
  end

  shared_examples 'ceilometer::agent::polling' do
    context 'with default params' do
      it { should contain_class('ceilometer::deps') }
      it { should contain_class('ceilometer::params') }

      it {
        if platform_params[:libvirt_group]
          should contain_user('ceilometer').with_groups(['nova', "#{platform_params[:libvirt_group]}"])
        else
          should contain_user('ceilometer').with_groups(['nova'])
        end
      }

      it { should contain_user('ceilometer').with(
        :ensure  => 'present',
        :name    => 'ceilometer',
        :gid     => 'ceilometer',
        :groups  => platform_params[:ceilometer_groups],
        :require => 'Anchor[ceilometer::install::end]',
      ) }

      it { should contain_package('nova-common').with(
       :before => /User\[ceilometer\]/
      )}

      it {
        should contain_ceilometer_config('compute/instance_discovery_method').with_value('<SERVICE DEFAULT>')
        should contain_ceilometer_config('compute/resource_update_interval').with_value('<SERVICE DEFAULT>')
        should contain_ceilometer_config('compute/resource_cache_expiry').with_value('<SERVICE DEFAULT>')
      }

      it 'shoud install the polling package' do
        should contain_package('ceilometer-polling').with(
          :ensure => 'present',
          :name   => platform_params[:agent_polling_package_name],
          :tag    => ['openstack', 'ceilometer-package'],
        )
        should_not contain_package('ceilometer-central')
        should_not contain_package('ceilometer-compute')
        should_not contain_package('ceilometer-ipmi')
      end

      it { should contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('central,compute,ipmi') }

      it 'should enable the polling service' do
        should contain_service('ceilometer-polling').with(
          :ensure     => 'running',
          :name       => platform_params[:agent_polling_service_name],
          :enable     => true,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'ceilometer-service',
        )
        should_not contain_service('ceilometer-central')
        should_not contain_service('ceilometer-compute')
        should_not contain_service('ceilometer-ipmi')
      end

      it { should contain_ceilometer_config('polling/batch_size').with_value('<SERVICE DEFAULT>') }
      it { should_not contain_file('polling') }
      it { should contain_ceilometer_config('polling/tenant_name_discovery').with_value('<SERVICE DEFAULT>') }
      it { should contain_ceilometer_config('polling/enable_notifications').with_value('<SERVICE DEFAULT>') }
      it { should contain_ceilometer_config('polling/enable_prometheus_exporter').with_value('<SERVICE DEFAULT>') }
      it { should contain_ceilometer_config('polling/prometheus_listen_addresses').with_value('<SERVICE DEFAULT>') }
      it { should contain_ceilometer_config('polling/pollsters_definitions_dirs').with_value('<SERVICE DEFAULT>') }
      it { should contain_ceilometer_config('polling/cfg_file').with_value('<SERVICE DEFAULT>') }
    end

    context 'when setting package_ensure' do
      before do
        params.merge!( :package_ensure => 'latest' )
      end

      it { should contain_package('ceilometer-polling').with(
        :ensure => 'latest',
      )}
    end

    context 'when compute parameters set' do
      before do
        params.merge!(
          :instance_discovery_method => 'naive',
          :resource_update_interval  => 0,
          :resource_cache_expiry     => 3600,
        )
      end

      it {
        should contain_ceilometer_config('compute/instance_discovery_method').with_value('naive')
        should contain_ceilometer_config('compute/resource_update_interval').with_value(0)
        should contain_ceilometer_config('compute/resource_cache_expiry').with_value(3600)
      }
    end

    context 'when common parameters are set' do
      before do
        params.merge!(
          :tenant_name_discovery       => true,
          :enable_notifications        => true,
          :enable_prometheus_exporter  => false,
          :prometheus_listen_addresses => ['127.0.0.1:9101'],
          :pollsters_definitions_dirs  => ['/etc/ceilometer/pollsters.d', '/etc/ceilometer/mypollsters.d']
        )
      end

      it {
        should contain_ceilometer_config('polling/tenant_name_discovery').with_value(true)
        should contain_ceilometer_config('polling/enable_notifications').with_value(true)
        should contain_ceilometer_config('polling/enable_prometheus_exporter').with_value(false)
        should contain_ceilometer_config('polling/prometheus_listen_addresses').with_value('127.0.0.1:9101')
        should contain_ceilometer_config('polling/pollsters_definitions_dirs').with_value(
          '/etc/ceilometer/pollsters.d,/etc/ceilometer/mypollsters.d')
      }
    end

    context 'with compute namespace disabled' do
      before do
        params.merge!(
          :compute_namespace => false
        )
      end

      it {
        should contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('central,ipmi')
        should contain_ceilometer_config('compute/instance_discovery_method').with_ensure('absent')
        should contain_ceilometer_config('compute/resource_update_interval').with_ensure('absent')
        should contain_ceilometer_config('compute/resource_cache_expiry').with_ensure('absent')
      }
    end

    context 'with central namespace disabled' do
      before do
        params.merge!(
          :central_namespace => false,
        )
      end

      it {
        should contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('compute,ipmi')
       }
    end

    context 'with central and ipmi polling namespaces disabled' do
      before do
        params.merge!(
          :central_namespace => false,
          :ipmi_namespace    => false
        )
      end

      it { should contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('compute') }
    end

    context 'with all namespaces disabled' do
      before do
        params.merge!(
          :compute_namespace => false,
          :central_namespace => false,
          :ipmi_namespace    => false
        )
      end

      it { should contain_ceilometer_config('DEFAULT/polling_namespaces').with_ensure('absent') }
    end

    context 'with service disabled' do
      before do
        params.merge!( :enabled => false )
      end

      it { should contain_service('ceilometer-polling').with(
        :ensure     => 'stopped',
        :name       => platform_params[:agent_polling_service_name],
        :enable     => false,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'ceilometer-service',
      )}
    end

    context 'with service unmanaged' do
      before do
        params.merge!( :manage_service => false )
      end

      it { should_not contain_service('ceilometer-polling') }
    end

    context 'with polling management enabled and default meters' do
      before do
        params.merge!( :manage_polling => true )
     end

      it { should contain_file('polling').with(
        :ensure                  => 'present',
        :path                    => '/etc/ceilometer/polling.yaml',
        :content                 => '---
sources:
    - name: some_pollsters
      interval: 300
      meters:
        - cpu
        - cpu_l3_cache
        - memory.usage
        - network.incoming.bytes
        - network.incoming.packets
        - network.outgoing.bytes
        - network.outgoing.packets
        - disk.device.read.bytes
        - disk.device.read.requests
        - disk.device.write.bytes
        - disk.device.write.requests
        - volume.size
        - volume.snapshot.size
        - volume.backup.size
',
        :selinux_ignore_defaults => true,
        :tag                     => 'ceilometer-yamls',
      )}
      it { should contain_ceilometer_config('polling/cfg_file').with_value('/etc/ceilometer/polling.yaml') }
    end

    context 'with polling and basic custom settings' do
      before do
        params.merge!( :manage_polling   => true,
                       :polling_interval => 30,
                       :polling_meters   => ['meter1', 'meter2'] )
      end

      it { should contain_file('polling').with(
        :ensure  => 'present',
        :path    => '/etc/ceilometer/polling.yaml',
        :content                 => '---
sources:
    - name: some_pollsters
      interval: 30
      meters:
        - meter1
        - meter2
',
        :selinux_ignore_defaults => true,
        :tag                     => 'ceilometer-yamls',
      )}
      it { should contain_ceilometer_config('polling/cfg_file').with_value('/etc/ceilometer/polling.yaml') }
    end

    context 'with polling and custom config' do
      before do
        params.merge!( :manage_polling => true,
                       :polling_config => {
          'sources' => [
            'name'     => 'my_pollsters',
            'interval' => 60,
            'meters'   => [
              'meterfoo',
              'meterbar',
            ],
          ],
        } )
      end

      it { should contain_file('polling').with(
        :ensure  => 'present',
        :path    => '/etc/ceilometer/polling.yaml',
        :content                 => '---
sources:
- name: my_pollsters
  interval: 60
  meters:
  - meterfoo
  - meterbar
',
      )}
      it { should contain_ceilometer_config('polling/cfg_file').with_value('/etc/ceilometer/polling.yaml') }
    end

    context 'with polling management disabled' do
      before do
        params.merge!( :manage_polling => false )
      end

      it { should_not contain_file('polling') }
      it { should contain_ceilometer_config('polling/cfg_file').with_value('<SERVICE DEFAULT>') }
    end

    context 'when batch_size is set' do
      before do
        params.merge!( :batch_size => 50 )
      end

      it { should contain_ceilometer_config('polling/batch_size').with_value(50) }
    end

    context 'with separate agents' do
      before do
        params.merge!( :separate_services => true )
      end

      it 'should install the agent packages' do
        should_not contain_package('ceilometer-polling')
        should contain_package('ceilometer-central').with(
          :ensure => 'present',
          :name   => platform_params[:agent_central_package_name],
          :tag    => ['openstack', 'ceilometer-package'],
        )
        should contain_package('ceilometer-compute').with(
          :ensure => 'present',
          :name   => platform_params[:agent_compute_package_name],
          :tag    => ['openstack', 'ceilometer-package'],
        )
        should contain_package('ceilometer-ipmi').with(
          :ensure => 'present',
          :name   => platform_params[:agent_ipmi_package_name],
          :tag    => ['openstack', 'ceilometer-package'],
        )
      end

      it { should contain_ceilometer_config('DEFAULT/polling_namespaces').with_ensure('absent') }

      it 'should enable the agent services' do
        should_not contain_service('ceilometer-polling')
        should contain_service('ceilometer-central').with(
          :ensure     => 'running',
          :name       => platform_params[:agent_central_service_name],
          :enable     => true,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'ceilometer-service',
        )
        should contain_service('ceilometer-compute').with(
          :ensure     => 'running',
          :name       => platform_params[:agent_compute_service_name],
          :enable     => true,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'ceilometer-service',
        )
        should contain_service('ceilometer-ipmi').with(
          :ensure     => 'running',
          :name       => platform_params[:agent_ipmi_service_name],
          :enable     => true,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'ceilometer-service',
        )
      end
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
            {
              :agent_polling_package_name => 'ceilometer-polling',
              :agent_polling_service_name => 'ceilometer-polling',
              :agent_central_package_name => 'ceilometer-agent-central',
              :agent_central_service_name => 'ceilometer-agent-central',
              :agent_compute_package_name => 'ceilometer-agent-compute',
              :agent_compute_service_name => 'ceilometer-agent-compute',
              :agent_ipmi_package_name    => 'ceilometer-agent-ipmi',
              :agent_ipmi_service_name    => 'ceilometer-agent-ipmi',
              :libvirt_group              => 'libvirt',
              :ceilometer_groups          => ['nova', 'libvirt'],
            }
        when 'RedHat'
            {
              :agent_polling_package_name => 'openstack-ceilometer-polling',
              :agent_polling_service_name => 'openstack-ceilometer-polling',
              :agent_central_package_name => 'openstack-ceilometer-central',
              :agent_central_service_name => 'openstack-ceilometer-central',
              :agent_compute_package_name => 'openstack-ceilometer-compute',
              :agent_compute_service_name => 'openstack-ceilometer-compute',
              :agent_ipmi_package_name    => 'openstack-ceilometer-ipmi',
              :agent_ipmi_service_name    => 'openstack-ceilometer-ipmi',
              :ceilometer_groups          => ['nova'],
            }
        end
      end

      it_behaves_like 'ceilometer::agent::polling'
    end
  end

end
