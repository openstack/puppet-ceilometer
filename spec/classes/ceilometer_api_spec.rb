require 'spec_helper'

describe 'ceilometer::api' do

  let :pre_condition do
    "class { 'ceilometer': telemetry_secret => 's3cr3t' }
     include ::ceilometer::db"
  end

  let :params do
    { :enabled        => true,
      :manage_service => true,
      :keystone_password => 'ceilometer-passw0rd',
      :host           => '0.0.0.0',
      :port           => '8777',
      :package_ensure => 'latest',
    }
  end

  shared_examples_for 'ceilometer-api' do

    it { is_expected.to contain_class('ceilometer::params') }
    it { is_expected.to contain_class('ceilometer::policy') }
    it { is_expected.to contain_class('ceilometer::keystone::authtoken') }

    it 'installs ceilometer-api package' do
      is_expected.to contain_package('ceilometer-api').with(
        :ensure => 'latest',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'ceilometer-package'],
      )
    end

    it 'configures api' do
      is_expected.to contain_ceilometer_config('api/host').with_value( params[:host] )
      is_expected.to contain_ceilometer_config('api/port').with_value( params[:port] )
      is_expected.to contain_ceilometer_config('api/workers').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('oslo_middleware/enable_proxy_headers_parsing').with_value('<SERVICE DEFAULT>')
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures ceilometer-api service' do
          is_expected.to contain_service('ceilometer-api').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:api_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :require    => 'Class[Ceilometer::Db]',
            :tag        => 'ceilometer-service',
          )
        end
      end
    end

    context 'with deprecated parameters' do
      before do
        params.merge!({
          :auth_uri           => 'https://10.0.0.1:5000/deprecated',
          :keystone_user      => 'myuser',
          :keystone_password  => 'mypasswd',
          :identity_uri       => 'http://10.0.0.1:35357/deprecated',
          :keystone_tenant    => 'service_project',
          :memcached_servers  => ['memcached01:11211','memcached02:11211'],
        })
      end

      it 'configures keystone_authtoken middleware' do
        is_expected.to contain_ceilometer_config(
          'keystone_authtoken/auth_uri').with_value(params[:auth_uri])
        is_expected.to contain_ceilometer_config(
          'keystone_authtoken/username').with_value(params[:keystone_user])
        is_expected.to contain_ceilometer_config(
          'keystone_authtoken/password').with_value(params[:keystone_password]).with_secret(true)
        is_expected.to contain_ceilometer_config(
          'keystone_authtoken/auth_url').with_value(params[:identity_uri])
        is_expected.to contain_ceilometer_config(
          'keystone_authtoken/project_name').with_value(params[:keystone_tenant])
        is_expected.to contain_ceilometer_config(
          'keystone_authtoken/memcached_servers').with_value('memcached01:11211,memcached02:11211')
      end
    end

    context 'with enable_proxy_headers_parsing' do
      before do
        params.merge!({:enable_proxy_headers_parsing => true })
      end

      it { is_expected.to contain_ceilometer_config('oslo_middleware/enable_proxy_headers_parsing').with_value(true) }
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures ceilometer-api service' do
        is_expected.to contain_service('ceilometer-api').with(
          :ensure     => nil,
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'ceilometer-service',
        )
      end
    end

    context 'when running ceilometer-api in wsgi' do
      before do
        params.merge!({ :service_name   => 'httpd' })
      end

      let :pre_condition do
        "include ::apache
         include ::ceilometer::db
         class { 'ceilometer': telemetry_secret => 's3cr3t' }"
      end

      it 'configures ceilometer-api service with Apache' do
        is_expected.to contain_service('ceilometer-api').with(
          :ensure     => 'stopped',
          :name       => platform_params[:api_service_name],
          :enable     => false,
          :tag        => 'ceilometer-service',
        )
      end
    end

    context 'when service_name is not valid' do
      before do
        params.merge!({ :service_name   => 'foobar' })
      end

      let :pre_condition do
        "include ::apache
         include ::ceilometer::db
         class { 'ceilometer': telemetry_secret => 's3cr3t' }"
      end

      it_raises 'a Puppet::Error', /Invalid service_name/
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '8.0',
        :concat_basedir         => '/var/lib/puppet/concat',
        :fqdn                   => 'some.host.tld',
        :processorcount         => 2 })
    end

    let :platform_params do
      { :api_package_name => 'ceilometer-api',
        :api_service_name => 'ceilometer-api' }
    end

    it_configures 'ceilometer-api'
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '7.1',
        :operatingsystemmajrelease => '7',
        :fqdn                   => 'some.host.tld',
        :concat_basedir         => '/var/lib/puppet/concat',
        :processorcount         => 2 })
    end

    let :platform_params do
      { :api_package_name => 'openstack-ceilometer-api',
        :api_service_name => 'openstack-ceilometer-api' }
    end

    it_configures 'ceilometer-api'
  end

end
