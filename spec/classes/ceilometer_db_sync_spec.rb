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


  context 'on a RedHat osfamily' do
    let :facts do
      {
        :osfamily                 => 'RedHat',
        :operatingsystemrelease   => '7.0',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'ceilometer-dbsync'
  end

  context 'on a Debian osfamily' do
    let :facts do
      {
        :operatingsystemrelease => '7.8',
        :operatingsystem        => 'Debian',
        :osfamily               => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'ceilometer-dbsync'
  end

end
