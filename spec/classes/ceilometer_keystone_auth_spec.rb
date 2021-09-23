require 'spec_helper'

describe 'ceilometer::keystone::auth' do

  let :default_params do
    {
      :email     => 'ceilometer@localhost',
      :auth_name => 'ceilometer',
      :region    => 'RegionOne',
      :tenant    => 'services',
    }
  end

  shared_examples_for 'ceilometer keystone auth' do

    context 'without the required password parameter' do
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    let :params do
      { :password => 'ceil0met3r-passZord' }
    end

    context 'with the required parameters' do
      it 'configures ceilometer user' do
        is_expected.to contain_keystone_user( default_params[:auth_name] ).with(
          :ensure   => 'present',
          :password => params[:password],
          :email    => default_params[:email],
        )
      end

      it 'configures ceilometer user roles' do
        is_expected.to contain_keystone_user_role("#{default_params[:auth_name]}@#{default_params[:tenant]}").with(
          :ensure => 'present',
        )
      end
    end

    context 'with overridden parameters' do
      before do
        params.merge!({
          :email         => 'mighty-ceilometer@remotehost',
          :auth_name     => 'mighty-ceilometer',
          :region        => 'RegionFortyTwo',
          :tenant        => 'mighty-services',
        })
      end

      it 'configures ceilometer user' do
        is_expected.to contain_keystone_user( params[:auth_name] ).with(
          :ensure   => 'present',
          :password => params[:password],
          :email    => params[:email],
        )
      end

      it 'configures ceilometer user roles' do
        is_expected.to contain_keystone_user_role("#{params[:auth_name]}@#{params[:tenant]}").with(
          :ensure => 'present',
        )
      end
    end

    context 'when disabling user configuration' do
      before do
        params.merge!( :configure_user => false )
      end

      it { is_expected.to_not contain_keystone_user('ceilometer') }
      it { is_expected.to contain_keystone_user_role('ceilometer@services') }
    end

    context 'when disabling user and role configuration' do
      before do
        params.merge!(
          :configure_user       => false,
          :configure_user_role  => false
        )
      end

      it { is_expected.to_not contain_keystone_user('ceilometer') }
      it { is_expected.to_not contain_keystone_user_role('ceilometer@services') }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'ceilometer keystone auth'
    end
  end

end
