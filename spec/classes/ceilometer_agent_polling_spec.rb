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

      it { should contain_package('nova-common').with(
       :before => /Package\[ceilometer-common\]/
      )}

      it { should contain_ceilometer_config('compute/instance_discovery_method').with_value('<SERVICE DEFAULT>') }

      it { should contain_package('ceilometer-polling').with(
        :ensure => 'present',
        :name   => platform_params[:agent_package_name],
        :tag    => ['openstack', 'ceilometer-package'],
      )}

      it { should contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('central,compute,ipmi') }

      it { should contain_service('ceilometer-polling').with(
        :ensure     => 'running',
        :name       => platform_params[:agent_service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'ceilometer-service',
      )}

      it { should_not contain_ceilometer_config('coordination/backend_url') }
      it { should_not contain_file('polling') }
    end

    context 'when setting package_ensure' do
      before do
        params.merge!( :package_ensure => 'latest' )
      end

      it { should contain_package('ceilometer-polling').with(
        :ensure => 'latest',
      )}
    end

    context 'when setting instance_discovery_method' do
      before do
        params.merge!( :instance_discovery_method => 'naive' )
      end

      it { should contain_ceilometer_config('compute/instance_discovery_method').with_value('naive') }
    end

    context 'with central and ipmi polling namespaces disabled' do
      before do
        params.merge!( :central_namespace => false,
                       :ipmi_namespace    => false )
      end

      it { should contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('compute') }
    end

    context 'with disabled service managing' do
      before do
        params.merge!( :manage_service => false,
                       :enabled        => false )
      end

      it { should contain_service('ceilometer-polling').with(
        :ensure     => nil,
        :name       => platform_params[:agent_service_name],
        :enable     => false,
        :hasstatus  => true,
        :hasrestart => true,
        :tag        => 'ceilometer-service',
      )}
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
      interval: 600
      meters:
        - cpu
        - cpu_l3_cache
        - memory.usage
        - network.incoming.bytes
        - network.incoming.packets
        - network.outgoing.bytes
        - network.outgoing.packets
        - disk.read.bytes
        - disk.read.requests
        - disk.write.bytes
        - disk.write.requests
        - volume.size
        - volume.snapshot.size
        - volume.backup.size
        - hardware.cpu.util
        - hardware.memory.used
        - hardware.memory.total
        - hardware.memory.buffer
        - hardware.memory.cached
        - hardware.memory.swap.avail
        - hardware.memory.swap.total
        - hardware.system_stats.io.outgoing.blocks
        - hardware.system_stats.io.incoming.blocks
        - hardware.network.ip.incoming.datagrams
        - hardware.network.ip.outgoing.datagrams
',
        :selinux_ignore_defaults => true,
        :tag                     => 'ceilometer-yamls',
      )}
    end

    context 'with polling and custom config' do
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
    end

    context 'with polling management disabled' do
      before do
        params.merge!( :manage_polling => false )
      end

      it { should_not contain_file('polling') }
    end

    context 'when setting coordination_url' do
      before do
        params.merge!( :coordination_url => 'redis://localhost:6379' )
      end

      it { should contain_ceilometer_config('coordination/backend_url').with_value('redis://localhost:6379') }
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
            {
              :agent_package_name => 'ceilometer-polling',
              :agent_service_name => 'ceilometer-polling',
              :libvirt_group      => 'libvirt'
            }
        when 'RedHat'
            {
              :agent_package_name => 'openstack-ceilometer-polling',
              :agent_service_name => 'openstack-ceilometer-polling'
            }
        end
      end

      it_behaves_like 'ceilometer::agent::polling'
    end
  end

end
