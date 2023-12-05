require 'spec_helper'

describe 'ceilometer::agent::service_credentials' do

  let :params do
    { :password => 'password' }
  end

  shared_examples_for 'ceilometer::agent::service_credentials' do

    context 'with default values' do
      it 'configures authentication' do
        is_expected.to contain_ceilometer_config('service_credentials/auth_url').with_value('http://localhost:5000')
        is_expected.to contain_ceilometer_config('service_credentials/region_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_credentials/username').with_value('ceilometer')
        is_expected.to contain_ceilometer_config('service_credentials/password').with_value('password').with_secret(true)
        is_expected.to contain_ceilometer_config('service_credentials/project_name').with_value('services')
        is_expected.to contain_ceilometer_config('service_credentials/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_credentials/cafile').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_credentials/interface').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_credentials/user_domain_name').with_value('Default')
        is_expected.to contain_ceilometer_config('service_credentials/project_domain_name').with_value('Default')
        is_expected.to contain_ceilometer_config('service_credentials/auth_type').with_value('password')
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!(
          :auth_url            => 'http://192.168.0.1:5000',
          :region_name         => 'regionOne',
          :username            => 'ceilometer2',
          :project_name        => 'services2',
          :cafile              => '/tmp/dummy.pem',
          :interface           => 'internalURL',
          :auth_type           => 'v3password',
          :user_domain_name    => 'MyDomain',
          :project_domain_name => 'MyProjDomain',
        )
      end

      it 'configures the specified values' do
        is_expected.to contain_ceilometer_config('service_credentials/auth_url').with_value('http://192.168.0.1:5000')
        is_expected.to contain_ceilometer_config('service_credentials/region_name').with_value('regionOne')
        is_expected.to contain_ceilometer_config('service_credentials/username').with_value('ceilometer2')
        is_expected.to contain_ceilometer_config('service_credentials/password').with_value('password').with_secret(true)
        is_expected.to contain_ceilometer_config('service_credentials/project_name').with_value('services2')
        is_expected.to contain_ceilometer_config('service_credentials/system_scope').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_credentials/cafile').with_value('/tmp/dummy.pem')
        is_expected.to contain_ceilometer_config('service_credentials/interface').with_value('internalURL')
        is_expected.to contain_ceilometer_config('service_credentials/user_domain_name').with_value('MyDomain')
        is_expected.to contain_ceilometer_config('service_credentials/project_domain_name').with_value('MyProjDomain')
        is_expected.to contain_ceilometer_config('service_credentials/auth_type').with_value('v3password')
      end
    end

    context 'when system_scope is set' do
      before do
        params.merge!(
          :system_scope => 'all'
        )
      end
      it 'configures system-scoped credential' do
        is_expected.to contain_ceilometer_config('service_credentials/project_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_credentials/project_domain_name').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_credentials/system_scope').with_value('all')
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

      it_behaves_like 'ceilometer::agent::service_credentials'
    end
  end

end
