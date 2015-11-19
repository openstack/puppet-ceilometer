require 'spec_helper'

describe 'ceilometer::db' do

  shared_examples 'ceilometer::db' do

    context 'with default parameters' do

      it { is_expected.to contain_class('ceilometer::params') }
      it { is_expected.to contain_class('ceilometer::db::sync') }
      it { is_expected.to contain_ceilometer_config('database/connection').with_value('mysql://ceilometer:ceilometer@localhost/ceilometer').with_secret(true) }
      it { is_expected.to contain_ceilometer_config('database/idle_timeout').with_value('3600') }
      it { is_expected.to contain_ceilometer_config('database/min_pool_size').with_value('1') }
      it { is_expected.to contain_ceilometer_config('database/max_retries').with_value('10') }
      it { is_expected.to contain_ceilometer_config('database/retry_interval').with_value('10') }
      it { is_expected.not_to contain_ceilometer_config('database/mongodb_replica_set') }

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mongodb://localhost:1234/ceilometer',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :sync_db                 => false }
      end

      it { is_expected.to contain_class('ceilometer::params') }
      it { is_expected.not_to contain_class('ceilometer::db::sync') }
      it { is_expected.to contain_ceilometer_config('database/connection').with_value('mongodb://localhost:1234/ceilometer').with_secret(true) }
      it { is_expected.to contain_ceilometer_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_ceilometer_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_ceilometer_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_ceilometer_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_ceilometer_config('database/mongodb_replica_set').with_ensure( 'absent' ) }

    end

    context 'with pymysql connection' do
      let :params do
        { :database_connection     => 'mysql+pymysql://ceilometer:ceilometer@localhost/ceilometer' }
      end

      it { is_expected.to contain_class('ceilometer::params') }
      it { is_expected.to contain_class('ceilometer::db::sync') }
      it { is_expected.to contain_ceilometer_config('database/connection').with_value('mysql+pymysql://ceilometer:ceilometer@localhost/ceilometer').with_secret(true) }
    end

    context 'with mongodb backend and replica set' do
      let :params do
        { :database_connection     => 'mongodb://localhost:1234/ceilometer',
          :mongodb_replica_set     => 'foobar' }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('ceilometer-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pymongo',
          :tag    => 'openstack'
        )
      end

      it { is_expected.to contain_ceilometer_config('database/mongodb_replica_set').with_value( 'foobar' ) }

    end


    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'redis://ceilometer:ceilometer@localhost/ceilometer', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://ceilometer:ceilometer@localhost/ceilometer', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection     => 'foo+pymysql://ceilometer:ceilometer@localhost/ceilometer', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie',
      }
    end

    it_configures 'ceilometer::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql:///ceilometer:ceilometer@localhost/ceilometer', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('ceilometer-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => 'openstack'
        )
      end
    end

    context 'with sqlite backend' do
      let :params do
        { :database_connection     => 'sqlite:///var/lib/ceilometer.db', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('ceilometer-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => 'openstack'
        )
      end

    end
  end

  context 'on Redhat platforms' do
    let :facts do
      { :osfamily => 'RedHat',
        :operatingsystemrelease => '7.1',
      }
    end

    it_configures 'ceilometer::db'

    context 'using pymysql driver' do
      let :params do
        { :database_connection     => 'mysql+pymysql:///ceilometer:ceilometer@localhost/ceilometer', }
      end

      it { is_expected.not_to contain_package('ceilometer-backend-package') }
    end
  end

end

