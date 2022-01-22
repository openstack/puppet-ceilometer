#
# Unit tests for ceilometer::keystone::auth
#

require 'spec_helper'

describe 'ceilometer::keystone::auth' do
  shared_examples_for 'ceilometer::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'ceilometer_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('ceilometer').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => false,
        :configure_service   => false,
        :region              => 'RegionOne',
        :auth_name           => 'ceilometer',
        :password            => 'ceilometer_password',
        :email               => 'ceilometer@localhost',
        :tenant              => 'services',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'ceilometer_password',
          :auth_name           => 'alt_ceilometer',
          :email               => 'alt_ceilometer@alt_localhost',
          :tenant              => 'alt_service',
          :configure_user      => false,
          :configure_user_role => false,
          :region              => 'RegionTwo' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('ceilometer').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :configure_service   => false,
        :region              => 'RegionTwo',
        :auth_name           => 'alt_ceilometer',
        :password            => 'ceilometer_password',
        :email               => 'alt_ceilometer@alt_localhost',
        :tenant              => 'alt_service',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'ceilometer::keystone::auth'
    end
  end
end
