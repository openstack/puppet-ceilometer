require 'spec_helper'

describe 'ceilometer::agent::polling::rgw' do
  shared_examples 'ceilometer::agent::polling::rgw' do
    context 'with default parameters' do
      it 'configures the default values' do
        is_expected.to contain_ceilometer_config('rgw_admin_credentials/access_key').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_ceilometer_config('rgw_admin_credentials/secret_key').with_value('<SERVICE DEFAULT>').with_secret(true)
        is_expected.to contain_ceilometer_config('rgw_client/implicit_tenants').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :access_key       => 'access',
          :secret_key       => 'secret',
          :implicit_tenants => true,
        }
      end

      it 'configures the overridden values' do
        is_expected.to contain_ceilometer_config('rgw_admin_credentials/access_key').with_value('access')
        is_expected.to contain_ceilometer_config('rgw_admin_credentials/secret_key').with_value('secret')
        is_expected.to contain_ceilometer_config('rgw_client/implicit_tenants').with_value(true)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'ceilometer::agent::polling::rgw'
    end
  end
end
