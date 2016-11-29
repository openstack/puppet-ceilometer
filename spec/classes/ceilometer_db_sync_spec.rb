require 'spec_helper'

describe 'ceilometer::db::sync' do

  shared_examples_for 'ceilometer-dbsync' do

    it 'runs ceilometer-dbsync' do
      is_expected.to contain_exec('ceilometer-dbsync').with(
        :command     => 'ceilometer-upgrade --config-file=/etc/ceilometer/ceilometer.conf --skip-gnocchi-resource-types ',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :user        => 'ceilometer',
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[ceilometer::install::end]',
                         'Anchor[ceilometer::config::end]',
                         'Anchor[ceilometer::dbsync::begin]'],
        :notify      => 'Anchor[ceilometer::dbsync::end]',
      )
    end

    describe 'overriding extra_params' do
      let :params do
        {
          :extra_params => '--config-file=/etc/ceilometer/ceilometer_01.conf',
        }
      end

      it { is_expected.to contain_exec('ceilometer-dbsync').with(
        :command    => 'ceilometer-upgrade --config-file=/etc/ceilometer/ceilometer.conf --skip-gnocchi-resource-types --config-file=/etc/ceilometer/ceilometer_01.conf',
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
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_behaves_like 'ceilometer-dbsync'
    end
  end

end
