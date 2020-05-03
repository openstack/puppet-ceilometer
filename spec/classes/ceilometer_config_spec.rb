require 'spec_helper'

describe 'ceilometer::config' do

  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples_for 'ceilometer_config' do
    let :params do
      { :ceilometer_config => config_hash }
    end

    it { is_expected.to contain_class('ceilometer::deps') }

    it 'configures arbitrary ceilometer-config configurations' do
      is_expected.to contain_ceilometer_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_ceilometer_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_ceilometer_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'ceilometer_config'
    end
  end
end
