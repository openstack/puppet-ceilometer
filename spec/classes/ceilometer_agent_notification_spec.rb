#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Unit tests for ceilometer::agent::notification
#

require 'spec_helper'

describe 'ceilometer::agent::notification' do

  let :pre_condition do
    "class { 'ceilometer': telemetry_secret => 's3cr3t' }"
  end

  let :params do
    { :manage_service     => true,
      :enabled            => true }
  end

  shared_examples_for 'ceilometer-agent-notification' do

    it { is_expected.to contain_class('ceilometer::deps') }
    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs ceilometer agent notification package' do
      is_expected.to contain_package(platform_params[:agent_notification_package_name]).with(
        :ensure => 'present',
        :tag    => ['openstack', 'ceilometer-package'],
      )
    end

    it 'configures notifications parameters in ceilometer.conf' do
      is_expected.to contain_ceilometer_config('notification/workers').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('notification/ack_on_event_error').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('notification/disable_non_metric_meters').with_value('<SERVICE DEFAULT>')
    end

    context 'with disabled non-metric meters' do
      before do
        params.merge!({ :disable_non_metric_meters => true })
      end
      it 'disables non-metric meters' do
        is_expected.to contain_ceilometer_config('notification/disable_non_metric_meters').with_value(params[:disable_non_metric_meters])
      end
    end

    [{:enabled => true}, {:enabled => false}].each do |param_hash|
      context "when service should be #{param_hash[:enabled] ? 'enabled' : 'disabled'}" do
        before do
          params.merge!(param_hash)
        end

        it 'configures ceilometer agent notification service' do
          is_expected.to contain_service('ceilometer-agent-notification').with(
            :ensure     => (params[:manage_service] && params[:enabled]) ? 'running' : 'stopped',
            :name       => platform_params[:agent_notification_service_name],
            :enable     => params[:enabled],
            :hasstatus  => true,
            :hasrestart => true,
            :tag        => 'ceilometer-service'
          )
        end
      end
    end

    context 'with disabled service managing' do
      before do
        params.merge!({
          :manage_service => false,
          :enabled        => false })
      end

      it 'configures ceilometer-agent-notification service' do
        is_expected.to contain_service('ceilometer-agent-notification').with(
          :ensure     => nil,
          :name       => platform_params[:agent_notification_service_name],
          :enable     => false,
          :hasstatus  => true,
          :hasrestart => true,
          :tag        => 'ceilometer-service'
        )
      end
    end

    context 'with multiple messaging urls' do
      before do
        params.merge!({
          :messaging_urls => ['rabbit://rabbit_user:password@localhost/nova',
                              'rabbit://rabbit_user:password@localhost/neutron'] })
      end

      it 'configures two messaging urls' do
        is_expected.to contain_ceilometer_config('notification/messaging_urls').with_value(
          ['rabbit://rabbit_user:password@localhost/nova', 'rabbit://rabbit_user:password@localhost/neutron']
        ).with_secret(true)
      end
    end

    context "with event_pipeline management enabled" do
      before { params.merge!(
        :manage_event_pipeline => true
      ) }

      it { is_expected.to contain_file('event_pipeline').with(
        'path'  => '/etc/ceilometer/event_pipeline.yaml',
        'owner' => 'root',
        'group' => 'ceilometer',
        'mode'  => '0640',
      ) }

      it { 'configures event_pipeline with the default notifier'
        verify_contents(catalogue, 'event_pipeline', [
          "---",
          "sources:",
          "    - name: event_source",
          "      events:",
          "          - \"*\"",
          "      sinks:",
          "          - event_sink",
          "sinks:",
          "    - name: event_sink",
          "      transformers:",
          "      triggers:",
          "      publishers:",
          "          - gnocchi://",
      ])}
    end

    context "with multiple event_pipeline publishers specified" do
      before { params.merge!(
        :manage_event_pipeline => true,
        :event_pipeline_publishers => ['notifier://', 'notifier://?topic=alarm.all']
      ) }

      it { 'configures event_pipeline with multiple publishers'
        verify_contents(catalogue, 'event_pipeline', [
          "---",
          "sources:",
          "    - name: event_source",
          "      events:",
          "          - \"*\"",
          "      sinks:",
          "          - event_sink",
          "sinks:",
          "    - name: event_sink",
          "      transformers:",
          "      triggers:",
          "      publishers:",
          "          - notifier://",
          "          - notifier://?topic=alarm.all",
      ])}
    end

    context 'with event_pipeline and custom config' do
      before { params.merge!(
        :manage_event_pipeline => true,
        :event_pipeline_config => {
          'sources' => [
            'name'   => 'my_event_source',
            'events' => ['*'],
            'sinks'  => ['my_event_sink'],
          ],
          'sinks'   => [
            'name'         => 'my_event_sink',
            'transformers' => [],
            'triggers'     => [],
            'publishers'   => ['gnocchi://'],
          ],
        }
      )}

      it { should contain_file('event_pipeline').with(
        :content                 => '---
sources:
- name: my_event_source
  events:
  - "*"
  sinks:
  - my_event_sink
sinks:
- name: my_event_sink
  transformers: []
  triggers: []
  publishers:
  - gnocchi://
',
      )}
    end

    context "with event_pipeline management disabled" do
      before { params.merge!(
        :manage_event_pipeline => false
      ) }
        it { is_expected.not_to contain_file('event_pipeline') }
    end

    context "with pipeline management enabled" do
      before { params.merge!(
        :manage_pipeline => true
      ) }

      it { is_expected.to contain_file('pipeline').with(
        'path' => '/etc/ceilometer/pipeline.yaml',
        'mode'  => '0640',
        'owner' => 'root',
        'group' => 'ceilometer',
      ) }
    end

    context 'with pipeline and custom config' do
      before { params.merge!(
        :manage_pipeline => true,
        :pipeline_config => {
          'sources' => [
            'name'   => 'my_source',
            'meters' => ['*'],
            'sinks'  => ['my_sink'],
          ],
          'sinks'   => [
            'name'         => 'my_sink',
            'transformers' => [],
            'publishers'   => ['gnocchi://'],
          ],
        }
      )}

      it { should contain_file('pipeline').with(
        :content                 => '---
sources:
- name: my_source
  meters:
  - "*"
  sinks:
  - my_sink
sinks:
- name: my_sink
  transformers: []
  publishers:
  - gnocchi://
',
      )}
    end

    context "with pipeline management disabled" do
      before { params.merge!(
        :manage_pipeline => false
      ) }
        it { is_expected.not_to contain_file('pipeline') }
    end

    context 'with custom ack_on_event_error' do
      before do
        params.merge!( :ack_on_event_error => true )
      end

      it { is_expected.to contain_ceilometer_config('notification/ack_on_event_error').with_value(true) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let :platform_params do
        case facts[:osfamily]
        when 'Debian'
          { :agent_notification_package_name => 'ceilometer-agent-notification',
            :agent_notification_service_name => 'ceilometer-agent-notification' }
        when 'RedHat'
          { :agent_notification_package_name => 'openstack-ceilometer-notification',
            :agent_notification_service_name => 'openstack-ceilometer-notification' }
        end
      end

      it_behaves_like 'ceilometer-agent-notification'
    end
  end

end
