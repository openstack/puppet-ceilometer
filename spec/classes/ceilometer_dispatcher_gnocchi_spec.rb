require 'spec_helper'

describe 'ceilometer::dispatcher::gnocchi' do

  let :pre_condition do
    "class { 'ceilometer': telemetry_secret => 's3cr3t' }"
  end

  let :params do
    {}
  end

  shared_examples_for 'ceilometer-gnocchi-dispatcher' do
    it 'configures gnocchi dispatcher' do
      is_expected.to contain_ceilometer_config('dispatcher_gnocchi/filter_service_activity').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('dispatcher_gnocchi/filter_project').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('dispatcher_gnocchi/archive_policy').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('dispatcher_gnocchi/resources_definition_file').with_value('<SERVICE DEFAULT>')
    end

    context 'when overriding parameters' do
      before do
        params.merge!(:filter_service_activity   => false,
                      :filter_project            => 'gnocchi_swift',
                      :archive_policy            => 'high',
                      :resources_definition_file => 'foo')
      end
      it { is_expected.to contain_ceilometer_config('dispatcher_gnocchi/filter_service_activity').with_value('false') }
      it { is_expected.to contain_ceilometer_config('dispatcher_gnocchi/filter_project').with_value('gnocchi_swift') }
      it { is_expected.to contain_ceilometer_config('dispatcher_gnocchi/archive_policy').with_value('high') }
      it { is_expected.to contain_ceilometer_config('dispatcher_gnocchi/resources_definition_file').with_value('foo') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'ceilometer-gnocchi-dispatcher'
    end
  end

end
