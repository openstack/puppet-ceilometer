require 'spec_helper'

describe 'ceilometer::db' do

  # debian has "python-pymongo"
  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :params do
      { :database_connection => 'mongodb://localhost:1234/ceilometer' }
    end

    it { should include_class('ceilometer::params') }

    it 'installs python-mongodb package' do
      should contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'python-pymongo')
    end
  end

  # Fedora > 18 has python-pymongo too
  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'Redhat',
        :operatingsystem => 'Fedora',
        :operatingsystemrelease => 18
      }
    end

    let :params do
      { :database_connection => 'mongodb://localhost:1234/ceilometer' }
    end

    it { should include_class('ceilometer::params') }

    it 'installs pymongo package' do
      should contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'python-pymongo')
    end
  end

  # RHEL has pymongo
  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'Redhat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => 6.4
      }
    end

    let :params do
      { :database_connection => 'mongodb://localhost:1234/ceilometer' }
    end

    it { should include_class('ceilometer::params') }

    it 'installs pymongo package' do
      should contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'pymongo')
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
      { :database_connection => 'sqlite:///var/lib/ceilometer.db' }
    end

    it { should include_class('ceilometer::params') }

    it 'installs pymongo package' do
      should contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'python-sqlite2')
    end
  end

  # debian has "python-pysqlite2"
  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :params do
      { :database_connection => 'sqlite:///var/lib/ceilometer.db' }
    end

    it { should include_class('ceilometer::params') }

    it 'installs python-mongodb package' do
      should contain_package('ceilometer-backend-package').with(
        :ensure => 'present',
        :name => 'python-pysqlite2')
    end
  end

end

