require 'spec_helper'

describe 'ceilometer::db::sync' do

  shared_examples_for 'ceilometer-dbsync' do

    it 'runs ceilometer-dbsync' do
      is_expected.to contain_exec('ceilometer-dbsync').with(
        :command     => 'ceilometer-dbsync --config-file=/etc/ceilometer/ceilometer.conf ',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :user        => 'ceilometer',
        :logoutput   => 'on_failure'
      )
    end

    describe 'overriding extra_params' do
      let :params do
        {
          :extra_params => '--config-file=/etc/ceilometer/ceilometer_01.conf',
        }
      end

      it { is_expected.to contain_exec('ceilometer-dbsync').with(
        :command    => 'ceilometer-dbsync --config-file=/etc/ceilometer/ceilometer.conf --config-file=/etc/ceilometer/ceilometer_01.conf',
        :path       => '/usr/bin',
        :user       => 'ceilometer',
        :refreshonly => 'true',
        :logoutput   => 'on_failure'
      )
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :processorcount => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'ceilometer-dbsync'
    end
  end

end
