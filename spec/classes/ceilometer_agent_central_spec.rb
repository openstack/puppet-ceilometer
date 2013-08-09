require 'spec_helper'

describe 'ceilometer::agent::central' do

  let :pre_condition do
    "class { 'ceilometer': metering_secret => 's3cr3t' }"
  end

  let :params do
    { :auth_url         => 'http://localhost:5000/v2.0',
      :auth_region      => 'RegionOne',
      :auth_user        => 'ceilometer',
      :auth_password    => 'password',
      :auth_tenant_name => 'services',
      :enabled          => true,
    }
  end

  shared_examples_for 'ceilometer-agent-central' do

    it { should include_class('ceilometer::params') }

    it 'installs ceilometer-agent-central package' do
      should contain_package('ceilometer-agent-central').with(
        :ensure => 'installed',
        :name   => platform_params[:agent_package_name],
        :before => 'Service[ceilometer-agent-central]'
      )
    end

    it 'ensures ceilometer-common is installed before the service' do
      should contain_package('ceilometer-common').with(
        :before => /Service\[ceilometer-agent-central\]/
      )
    end

    it 'configures ceilometer-agent-central service' do
      should contain_service('ceilometer-agent-central').with(
        :ensure     => 'running',
        :name       => platform_params[:agent_service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true
      )
    end

    it 'configures authentication' do
      should contain_ceilometer_config('DEFAULT/os_auth_url').with_value('http://localhost:5000/v2.0')
      should contain_ceilometer_config('DEFAULT/os_auth_region').with_value('RegionOne')
      should contain_ceilometer_config('DEFAULT/os_username').with_value('ceilometer')
      should contain_ceilometer_config('DEFAULT/os_password').with_value('password')
      should contain_ceilometer_config('DEFAULT/os_tenant_name').with_value('services')
    end

    context 'when overriding parameters' do
      before do
        params.merge!(:auth_cacert => '/tmp/dummy.pem')
      end
      it { should contain_ceilometer_config('DEFAULT/os_cacert').with_value(params[:auth_cacert]) }
    end
end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :agent_package_name => 'ceilometer-agent-central',
        :agent_service_name => 'ceilometer-agent-central' }
    end

    it_configures 'ceilometer-agent-central'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :agent_package_name => 'openstack-ceilometer-central',
        :agent_service_name => 'openstack-ceilometer-central' }
    end

    it_configures 'ceilometer-agent-central'
  end
end
