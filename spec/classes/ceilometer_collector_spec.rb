require 'spec_helper'

describe 'ceilometer::collector' do

  let :pre_condition do
    "class { 'ceilometer': metering_secret => 's3cr3t' }"
  end

  shared_examples_for 'ceilometer-collector' do

    context 'when enabled' do
      before do
        pre_condition << "class { 'ceilometer::db': }"
      end

      it { should contain_class('ceilometer::params') }

      it 'installs ceilometer-collector package' do
        should contain_package(platform_params[:collector_package_name])
      end

      it 'configures ceilometer-collector service' do
        should contain_service('ceilometer-collector').with(
          :ensure     => 'running',
          :name       => platform_params[:collector_service_name],
          :enable     => true,
          :hasstatus  => true,
          :hasrestart => true
        )
      end

      it 'configures relationships on database' do
        should contain_class('ceilometer::db').with_before('Service[ceilometer-collector]')
        should contain_exec('ceilometer-dbsync').with_notify('Service[ceilometer-collector]')
      end
    end

    context 'when disabled' do
      let :params do
        { :enabled => false }
      end

      # Catalog compilation does not crash for lack of ceilometer::db
      it { should compile }
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :collector_package_name => 'ceilometer-collector',
        :collector_service_name => 'ceilometer-collector' }
    end

    it_configures 'ceilometer-collector'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :collector_package_name => 'openstack-ceilometer-collector',
        :collector_service_name => 'openstack-ceilometer-collector' }
    end

    it_configures 'ceilometer-collector'
  end
end
