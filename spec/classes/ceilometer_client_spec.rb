require 'spec_helper'

describe 'ceilometer::client' do

  shared_examples_for 'ceilometer client' do

    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs ceilometer client package' do
      is_expected.to contain_package('python-ceilometerclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
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
        { :client_package_name => 'python-ceilometerclient' }
      end

      it_behaves_like 'ceilometer client'
    end
  end

end
