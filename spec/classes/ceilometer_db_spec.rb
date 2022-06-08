require 'spec_helper'

describe 'ceilometer::db' do
  shared_examples 'ceilometer::db' do
    context 'with default parameters' do
      it { should contain_class('ceilometer::deps') }

      it { should contain_oslo__db('ceilometer_config').with(
        :db_max_retries          => '<SERVICE DEFAULT>',
        :connection              => 'mysql+pymysql://ceilometer:ceilometer@localhost/ceilometer',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
        :mysql_enable_ndb        => '<SERVICE DEFAULT>',
      )}

      it { should contain_class('ceilometer::db::sync') }
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_db_max_retries          => '-1',
          :database_connection              => 'mysql+pymysql://ceilometer:ceilometer@localhost2/ceilometer',
          :database_connection_recycle_time => '3601',
          :database_max_pool_size           => '11',
          :database_max_retries             => '11',
          :database_retry_interval          => '11',
          :database_max_overflow            => '21',
          :database_pool_timeout            => '21',
          :mysql_enable_ndb                 => true,
          :sync_db                          => false }
      end

      it { should contain_class('ceilometer::deps') }

      it { should contain_oslo__db('ceilometer_config').with(
        :db_max_retries          => '-1',
        :connection              => 'mysql+pymysql://ceilometer:ceilometer@localhost2/ceilometer',
        :connection_recycle_time => '3601',
        :max_pool_size           => '11',
        :max_retries             => '11',
        :retry_interval          => '11',
        :max_overflow            => '21',
        :pool_timeout            => '21',
        :mysql_enable_ndb        => true,
      )}

      it { should_not contain_class('ceilometer::db::sync') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      it_behaves_like 'ceilometer::db'
    end
  end
end
