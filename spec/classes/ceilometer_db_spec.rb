require 'spec_helper'

describe 'ceilometer::db' do

  # debian has "python-pymongo"
  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :params do
      { :database_connection => 'mongodb://localhost:1234/ceilometer',
        :sync_db             => true }
    end

    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs python-mongodb package' do
      is_expected.to contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name   => 'python-pymongo',
        :tag    => 'openstack'
      )
      is_expected.to contain_ceilometer_config('database/connection').with_value('mongodb://localhost:1234/ceilometer')
      is_expected.to contain_ceilometer_config('database/connection').with_value( params[:database_connection] ).with_secret(true)
    end

    it 'includes ceilometer::db::sync' do
      is_expected.to contain_class('ceilometer::db::sync')
    end
  end

  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'Redhat',
        :operatingsystem => 'Fedora',
        :operatingsystemrelease => 21
      }
    end

    let :params do
      { :database_connection => 'mongodb://localhost:1234/ceilometer',
        :sync_db             => false }
    end

    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs pymongo package' do
      is_expected.to contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'python-pymongo')
      is_expected.to contain_ceilometer_config('database/connection').with_value('mongodb://localhost:1234/ceilometer')
      is_expected.to contain_ceilometer_config('database/connection').with_value( params[:database_connection] ).with_secret(true)
    end

    it 'does not include ceilometer::db::sync' do
      is_expected.not_to contain_class('ceilometer::db::sync')
    end
  end

  # RHEL has python-pymongo too
  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'Redhat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => 6.4
      }
    end

    let :params do
      { :database_connection => 'mongodb://localhost:1234/ceilometer',
        :sync_db             => true }
    end

    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs pymongo package' do
      is_expected.to contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'python-pymongo')
    end

    it 'includes ceilometer::db::sync' do
      is_expected.to contain_class('ceilometer::db::sync')
    end
  end

  # RHEL has python-sqlite2
  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'Redhat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => 6.4
      }
    end

    let :params do
      { :database_connection => 'sqlite:///var/lib/ceilometer.db',
        :sync_db             => false }
    end

    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs pymongo package' do
      is_expected.to contain_ceilometer_config('database/connection').with_value('sqlite:///var/lib/ceilometer.db')
      is_expected.to contain_ceilometer_config('database/connection').with_value( params[:database_connection] ).with_secret(true)
    end

    it 'does not include ceilomter::db::sync' do
      is_expected.not_to contain_class('ceilometer::db::sync')
    end
  end

  # debian has "python-pysqlite2"
  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :params do
      { :database_connection => 'sqlite:///var/lib/ceilometer.db',
        :sync_db             => true }
    end

    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs python-mongodb package' do
      is_expected.to contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'python-pysqlite2')
    end

    it 'includes ceilometer::db::sync' do
      is_expected.to contain_class('ceilometer::db::sync')
    end
  end

end

