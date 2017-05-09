require 'spec_helper'

describe 'ceilometer::agent::polling' do

  let :pre_condition do
    "include nova\n" +
    "include nova::compute\n" +
    "class { 'ceilometer': telemetry_secret => 's3cr3t' }"
  end

  let :params do
    { :enabled           => true,
      :manage_service    => true,
      :package_ensure    => 'latest',
      :central_namespace => true,
      :compute_namespace => true,
      :ipmi_namespace    => true,
      :coordination_url  => 'redis://localhost:6379',
    }
  end

  shared_examples_for 'ceilometer-polling' do

    it { is_expected.to contain_class('ceilometer::deps') }
    it { is_expected.to contain_class('ceilometer::params') }

    context 'when compute_namespace => true' do
      it 'adds ceilometer user to nova group and, if required, to libvirt group' do
        if platform_params[:libvirt_group]
          is_expected.to contain_user('ceilometer').with_groups(['nova', "#{platform_params[:libvirt_group]}"])
        else
          is_expected.to contain_user('ceilometer').with_groups(['nova'])
        end
      end

      it 'ensures nova-common is installed before the package ceilometer-common' do
          is_expected.to contain_package('nova-common').with(
              :before => /Package\[ceilometer-common\]/
          )
      end

      it 'configures agent compute' do
        is_expected.to contain_ceilometer_config('compute/instance_discovery_method').with_value('<SERVICE DEFAULT>')
      end
    end

    it 'installs ceilometer-polling package' do
      is_expected.to contain_package('ceilometer-polling').with(
        :ensure => 'latest',
        :name   => platform_params[:agent_package_name],
        :tag    => ['openstack', 'ceilometer-package'],
      )
    end

    it 'configures polling namespaces' do
      is_expected.to contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('central,compute,ipmi')
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures ceilometer-polling service' do
          is_expected.to contain_service('ceilometer-polling').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:agent_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'ceilometer-service',
          )
        end
      end
    end


    context 'when setting instance_discovery_method' do
      before do
        params.merge!({ :instance_discovery_method   => 'naive' })
      end

      it 'configures agent compute instance discovery' do
        is_expected.to contain_ceilometer_config('compute/instance_discovery_method').with_value('naive')
      end
    end

    context 'with central and ipmi polling namespaces disabled' do
      before do
        params.merge!({
          :central_namespace => false,
          :ipmi_namespace    => false })
      end

      it 'configures compute polling namespace' do
        is_expected.to contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('compute')
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures ceilometer-polling service' do
        is_expected.to contain_service('ceilometer-polling').with(
          :ensure     => nil,
          :name       => platform_params[:agent_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'ceilometer-service',
        )
      end
    end

    context "with polling management enabled" do
      before { params.merge!(
        :manage_polling   => true
      ) }

      it { is_expected.to contain_file('polling').with(
        'path' => '/etc/ceilometer/polling.yaml',
      ) }
    end

    context "with polling management disabled" do
      before { params.merge!(
        :manage_polling   => false
      ) }

      it { is_expected.not_to contain_file('polling') }
    end

    it 'configures central agent' do
      is_expected.to contain_ceilometer_config('coordination/backend_url').with_value( params[:coordination_url] )
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
            { :agent_package_name => 'ceilometer-polling',
              :agent_service_name => 'ceilometer-polling',
              :libvirt_group      => 'libvirt' }
        when 'RedHat'
            { :agent_package_name => 'openstack-ceilometer-polling',
              :agent_service_name => 'openstack-ceilometer-polling' }
        end
      end

      it_behaves_like 'ceilometer-polling'
    end
  end

end
