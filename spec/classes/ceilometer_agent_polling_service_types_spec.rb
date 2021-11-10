require 'spec_helper'

describe 'ceilometer::agent::polling::service_types' do
  shared_examples 'ceilometer::agent::polling::service_types' do
    context 'with default parameters' do
      it 'configures the default values' do
        is_expected.to contain_ceilometer_config('service_types/glance').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_types/neutron').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_types/nova').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_types/swift').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_ceilometer_config('service_types/cinder').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :glance  => 'image',
          :neutron => 'network',
          :nova    => 'compute',
          :swift   => 'object-store',
          :cinder  => 'volumev3',
        }
      end

      it 'configures the overridden values' do
        is_expected.to contain_ceilometer_config('service_types/glance').with_value('image')
        is_expected.to contain_ceilometer_config('service_types/neutron').with_value('network')
        is_expected.to contain_ceilometer_config('service_types/nova').with_value('compute')
        is_expected.to contain_ceilometer_config('service_types/swift').with_value('object-store')
        is_expected.to contain_ceilometer_config('service_types/cinder').with_value('volumev3')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'ceilometer::agent::polling::service_types'
    end
  end
end
