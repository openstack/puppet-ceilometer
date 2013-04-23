require 'spec_helper'

describe 'ceilometer::api' do

  let :pre_condition do
    "class { 'ceilometer': metering_secret => 's3cr3t' }"
  end

  let :params do
    { :enabled           => true,
      :keystone_host     => '127.0.0.1',
      :keystone_port     => '35357',
      :keystone_protocol => 'http',
      :keystone_user     => 'ceilometer',
      :keystone_password => 'ceilometer-passw0rd',
      :keystone_tenant   => 'services'
    }
  end

  shared_examples_for 'ceilometer-api' do

    context 'without required parameter keystone_password' do
      before { params.delete(:keystone_password) }
      it { expect { should raise_error(Puppet::Error) } }
    end

    it { should include_class('ceilometer::params') }

    it 'installs ceilometer-api package' do
      should contain_package('ceilometer-api').with(
        :ensure => 'installed',
        :name   => platform_params[:api_package_name]
      )
    end

    it 'configures ceilometer-api service' do
      should contain_service('ceilometer-api').with(
        :ensure     => 'running',
        :name       => platform_params[:api_service_name],
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :require    => 'Class[Ceilometer::Db]',
        :subscribe  => 'Exec[ceilometer-dbsync]'
      )
    end

    it 'configures keystone authentication middleware' do
      should contain_ceilometer_config('keystone_authtoken/auth_host').with_value( params[:keystone_host] )
      should contain_ceilometer_config('keystone_authtoken/auth_port').with_value( params[:keystone_port] )
      should contain_ceilometer_config('keystone_authtoken/auth_protocol').with_value( params[:keystone_protocol] )
      should contain_ceilometer_config('keystone_authtoken/admin_tenant_name').with_value( params[:keystone_tenant] )
      should contain_ceilometer_config('keystone_authtoken/admin_user').with_value( params[:keystone_user] )
      should contain_ceilometer_config('keystone_authtoken/admin_password').with_value( params[:keystone_password] )
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :api_package_name => 'ceilometer-api',
        :api_service_name => 'ceilometer-api' }
    end

    it_configures 'ceilometer-api'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :api_package_name => 'openstack-ceilometer-api',
        :api_service_name => 'openstack-ceilometer-api' }
    end

    it_configures 'ceilometer-api'
  end
end
