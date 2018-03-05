require 'spec_helper'

describe 'ceilometer::db' do

  shared_examples 'ceilometer::db' do

    context 'with default parameters' do

      it { is_expected.to contain_class('ceilometer::params') }
      it { is_expected.to contain_class('ceilometer::db::sync') }
      it { is_expected.to contain_oslo__db('ceilometer_config').with(
        :db_max_retries => '<SERVICE DEFAULT>',
        :connection     => 'mysql+pymysql://ceilometer:ceilometer@localhost/ceilometer',
        :idle_timeout   => '<SERVICE DEFAULT>',
        :min_pool_size  => '<SERVICE DEFAULT>',
        :max_pool_size  => '<SERVICE DEFAULT>',
        :max_retries    => '<SERVICE DEFAULT>',
        :retry_interval => '<SERVICE DEFAULT>',
        :max_overflow   => '<SERVICE DEFAULT>',
      )}

    end

    context 'with specific parameters' do
      let :params do
        {
          :database_db_max_retries => '-1',
          :database_connection     => 'mongodb://localhost:1234/ceilometer',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_pool_size  => '11',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_overflow   => '21',
          :sync_db                 => false }
      end

      it { is_expected.not_to contain_class('ceilometer::db::sync') }
      it { is_expected.to contain_oslo__db('ceilometer_config').with(
        :db_max_retries => '-1',
        :connection     => 'mongodb://localhost:1234/ceilometer',
        :idle_timeout   => '3601',
        :min_pool_size  => '2',
        :max_pool_size  => '11',
        :max_retries    => '11',
        :retry_interval => '11',
        :max_overflow   => '21',
      )}

    end

    context 'with pymysql connection' do
      let :params do
        { :database_connection => 'mysql+pymysql://ceilometer:ceilometer@localhost/ceilometer' }
      end

      it { is_expected.to contain_class('ceilometer::params') }
      it { is_expected.to contain_class('ceilometer::db::sync') }
      it { is_expected.to contain_oslo__db('ceilometer_config').with(
        :connection => 'mysql+pymysql://ceilometer:ceilometer@localhost/ceilometer',
      )}
    end

    context 'with mongodb backend' do
      let :params do
        { :database_connection => 'mongodb://localhost:1234/ceilometer' }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pymongo').with(
          :ensure => 'present',
          :name   => 'python-pymongo',
          :tag    => 'openstack'
        )
      end
    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection => 'redis://ceilometer:ceilometer@localhost/ceilometer', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection => 'postgresql://ceilometer:ceilometer@localhost/ceilometer', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end
    end

    context 'with incorrect pymysql database_connection string' do
      let :params do
        { :database_connection => 'foo+pymysql://ceilometer:ceilometer@localhost/ceilometer', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  shared_examples_for 'ceilometer::db on Debian' do
    context 'with sqlite backend' do
      let :params do
        { :database_connection => 'sqlite:///var/lib/ceilometer.db', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pysqlite2').with(
          :ensure => 'present',
          :name   => 'python-pysqlite2',
          :tag    => 'openstack'
        )
      end
    end

    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql:///ceilometer:ceilometer@localhost/ceilometer', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-pymysql').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => 'openstack'
        )
      end
    end
  end

  shared_examples_for 'ceilometer::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql:///ceilometer:ceilometer@localhost/ceilometer', }
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir         => '/var/lib/puppet/concat',
          :fqdn                   => 'some.host.tld',
        }))
      end

      case facts[:osfamily]
      when 'Debian'
        it_behaves_like 'ceilometer::db on Debian'
      when 'RedHat'
        it_behaves_like 'ceilometer::db on RedHat'
      end

      it_behaves_like 'ceilometer::db'
    end
  end

end
