require 'spec_helper'

describe 'ceilometer::db::sync' do

  shared_examples_for 'ceilometer-upgrade' do

    it 'runs ceilometer-upgrade' do
      is_expected.to contain_exec('ceilometer-upgrade').with(
        :command     => 'ceilometer-upgrade ',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :user        => 'ceilometer',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[ceilometer::install::end]',
                         'Anchor[ceilometer::config::end]',
                         'Anchor[ceilometer::dbsync::begin]'],
        :notify      => 'Anchor[ceilometer::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

    describe 'overriding extra_params' do
      let :params do
        {
          :extra_params => '--config-file=/etc/ceilometer/ceilometer_01.conf',
        }
      end

      it { is_expected.to contain_exec('ceilometer-upgrade').with(
        :command    => 'ceilometer-upgrade --config-file=/etc/ceilometer/ceilometer_01.conf',
        :path       => '/usr/bin',
        :user       => 'ceilometer',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[ceilometer::install::end]',
                         'Anchor[ceilometer::config::end]',
                         'Anchor[ceilometer::dbsync::begin]'],
        :notify      => 'Anchor[ceilometer::dbsync::end]',
        :tag         => 'openstack-db',
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

      it_behaves_like 'ceilometer-upgrade'
    end
  end

end
