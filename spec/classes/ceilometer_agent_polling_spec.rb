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
    end

    it 'installs ceilometer-polling package' do
      is_expected.to contain_package('ceilometer-polling').with(
        :ensure => 'latest',
        :name   => platform_params[:agent_package_name],
        :before => ['Service[ceilometer-polling]'],
        :tag    => ['openstack', 'ceilometer-package'],
      )
    end

    it 'configures polling namespaces' do
      is_expected.to contain_ceilometer_config('DEFAULT/polling_namespaces').with_value('central,compute,ipmi')
    end

    it 'ensures ceilometer-common is installed before the service' do
      is_expected.to contain_package('ceilometer-common').with(
        :before => /Service\[ceilometer-polling\]/
      )
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

    it 'configures central agent' do
      is_expected.to contain_ceilometer_config('coordination/backend_url').with_value( params[:coordination_url] )
    end

  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian' })
    end

    let :platform_params do
      { :agent_package_name => 'ceilometer-polling',
        :agent_service_name => 'ceilometer-polling' }
    end

    context 'on Ubuntu operating systems' do
      before do
        facts.merge!( :operatingsystem => 'Ubuntu' )
        platform_params.merge!( :libvirt_group => 'libvirtd' )
      end

      it_configures 'ceilometer-polling'
    end

    context 'on other operating systems' do
      before do
        platform_params.merge!( :libvirt_group => 'libvirt' )
      end

      it_configures 'ceilometer-polling'
    end

  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    let :platform_params do
      { :agent_package_name => 'openstack-ceilometer-polling',
        :agent_service_name => 'openstack-ceilometer-polling' }
    end

    it_configures 'ceilometer-polling'
  end
end
