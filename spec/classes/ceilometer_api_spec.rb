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

  context 'with all parameters' do

    it { should include_class('ceilometer::params') }

    it 'installs ceilometer-api package' do
      should contain_package('ceilometer-api').with(
        :ensure => 'installed'
      )
    end

    it 'configures ceilometer-api service' do
      should contain_service('ceilometer-api').with(
        :ensure     => 'running',
        :name       => 'ceilometer-api',
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
        :require    => ['Package[ceilometer-api]', 'Class[Ceilometer::Db]'],
        :subscribe  => 'Exec[ceilometer-dbsync]'
      )
    end

    it 'configures ceilometer with keystone' do
      should contain_ceilometer_config('keystone_authtoken/auth_host').with_value( params[:keystone_host] )
      should contain_ceilometer_config('keystone_authtoken/auth_port').with_value( params[:keystone_port] )
      should contain_ceilometer_config('keystone_authtoken/auth_protocol').with_value( params[:keystone_protocol] )
      should contain_ceilometer_config('keystone_authtoken/admin_tenant_name').with_value( params[:keystone_tenant] )
      should contain_ceilometer_config('keystone_authtoken/admin_user').with_value( params[:keystone_user] )
      should contain_ceilometer_config('keystone_authtoken/admin_password').with_value( params[:keystone_password] )
    end
  end
end
