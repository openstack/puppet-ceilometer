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
# == Class: ceilometer::agent::notification
#
# Configure the ceilometer notification agent.
# This configures the plugin for the API server, but does nothing
# about configuring the agents that must also run and share a config
# file with the OVS plugin if both are on the same machine.
#
# === Parameters:
#
# [*enabled*]
#   (Optional) Should the service be enabled.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional)  Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*ack_on_event_error*]
#   (Optional) Acknowledge message when event persistence fails.
#   Defaults to true.
#
# [*disable_non_metric_meters*]
#   (Optional) Disable or enable the collection of non-metric meters.
#   Default to $::os_service_default.
#
# [*notification_workers*]
#   (Optional) Number of workers for notification service (integer value).
#   Defaults to $::os_service_default.
#
# [*messaging_urls*]
#   (Optional) Messaging urls to listen for notifications. (Array of urls)
#   The format should be transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'.
#
# [*manage_event_pipeline*]
#   (Optional) Whether to manage event_pipeline.yaml
#   Defaults to false
#
# [*event_pipeline_publishers*]
#   (Optional) A list of publishers to put in event_pipeline.yaml
#   Add 'notifier://?topic=alarm.all' to the list if you are using Aodh
#   for alarms.
#   Defaults to ['gnocchi://'],
#
# [*manage_pipeline*]
#   (Optional) Whether to manage pipeline.yaml
#   Defaults to false
#
# [*pipeline_publishers*]
#   (Optional) A list of publishers to put in pipeline.yaml.
#   By default all the data is dispatched to gnocchi
#   Defaults to ['gnocchi://'], If you are using collector
#   override this to notifier:// instead.
#
class ceilometer::agent::notification (
  $manage_service            = true,
  $enabled                   = true,
  $ack_on_event_error        = true,
  $disable_non_metric_meters = $::os_service_default,
  $notification_workers      = $::os_service_default,
  $messaging_urls            = $::os_service_default,
  $package_ensure            = 'present',
  $manage_event_pipeline     = false,
  $event_pipeline_publishers = ['gnocchi://'],
  $manage_pipeline           = false,
  $pipeline_publishers       = ['gnocchi://'],
) {

  include ::ceilometer::deps
  include ::ceilometer::params

  ensure_resource('package', [$::ceilometer::params::agent_notification_package_name],
    {
      ensure => $package_ensure,
      tag    => ['openstack', 'ceilometer-package']
    }
  )

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'ceilometer-agent-notification':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::agent_notification_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'ceilometer-service'
  }

  if ($manage_event_pipeline) {
    validate_array($event_pipeline_publishers)

    file { 'event_pipeline':
      ensure                  => present,
      path                    => $::ceilometer::params::event_pipeline,
      content                 => template('ceilometer/event_pipeline.yaml.erb'),
      selinux_ignore_defaults => true,
      mode                    => '0640',
      owner                   => 'root',
      group                   => 'ceilometer',
      tag                     => 'ceilometer-yamls',
    }
  }

  if ($manage_pipeline) {
    validate_array($pipeline_publishers)

    file { 'pipeline':
      ensure                  => present,
      path                    => $::ceilometer::params::pipeline,
      content                 => template('ceilometer/pipeline.yaml.erb'),
      selinux_ignore_defaults => true,
      mode                    => '0640',
      owner                   => 'root',
      group                   => 'ceilometer',
      tag                     => 'ceilometer-yamls',
    }
  }

  ceilometer_config {
    'notification/ack_on_event_error'       : value => $ack_on_event_error;
    'notification/disable_non_metric_meters': value => $disable_non_metric_meters;
    'notification/workers'                  : value => $notification_workers;
    'notification/messaging_urls'           : value => $messaging_urls, secret => true;
  }
}
