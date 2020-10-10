require 'spec_helper'

describe 'ceilometer::db::postgresql' do

  shared_examples_for 'ceilometer::db::postgresql' do
    let :req_params do
      { :password => 'ceilometerpass' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('ceilometer::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('ceilometer').with(
        :user       => 'ceilometer',
        :password   => 'ceilometerpass',
        :dbname     => 'ceilometer',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
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

      it_configures 'ceilometer::db::postgresql'
    end
  end

end
