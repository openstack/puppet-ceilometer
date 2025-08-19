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
#   Defaults to $facts['os_service_default'].
#
# [*disable_non_metric_meters*]
#   (Optional) Disable or enable the collection of non-metric meters.
#   Default to $facts['os_service_default'].
#
# [*workers*]
#   (Optional) Number of workers for notification service (integer value).
#   Defaults to $facts['os_service_default'].
#
# [*messaging_urls*]
#   (Optional) Messaging urls to listen for notifications. (Array of urls)
#   The format should be transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default'].
#
# [*batch_size*]
#   (Optional) Number of notification messages to wait before publishing
#   them.
#   Defaults to $facts['os_service_default'].
#
# [*batch_timeout*]
#   (Optional) Number of seconds to wait before dispatching samples when
#   batch_size is not reached.
#   Defaults to $facts['os_service_default'].
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'.
#
# [*manage_event_pipeline*]
#   (Optional) Whether to manage event_pipeline.yaml
#   Defaults to false
#
# [*event_pipeline_config*]
#   (Optional) A hash of the event_pipeline.yaml configuration.
#   This is used only if manage_event_pipeline is true.
#   Defaults to undef
#
# [*event_pipeline_publishers*]
#   (Optional) A list of publishers to put in event_pipeline.yaml
#   Add 'notifier://?topic=alarm.all' to the list if you are using Aodh
#   for alarms.
#   Defaults to ['gnocchi://'],
#
# [*event_pipeline_cfg_file*]
#   (Optional) Configuration file for event pipeline definition. This parameter
#   has no effect when manage_event_pipeline is true.
#   Defaults to $facts['os_service_default'].
#
# [*manage_pipeline*]
#   (Optional) Whether to manage pipeline.yaml
#   Defaults to false
#
# [*pipeline_config*]
#   (Optional) A hash of the pipeline.yaml configuration.
#   This is used only if manage_pipeline is true.
#   Defaults to undef
#
# [*pipeline_publishers*]
#   (Optional) A list of publishers to put in pipeline.yaml.
#   By default all the data is dispatched to gnocchi
#   Defaults to ['gnocchi://'], If you are using collector
#   override this to notifier:// instead.
#
# [*pipeline_cfg_file*]
#   (Optional) Configuration file for pipeline definition. This parameter has
#   no effect when manage_pipeline is true.
#   Defaults to $facts['os_service_default'].
#
class ceilometer::agent::notification (
  Boolean $manage_service                     = true,
  Boolean $enabled                            = true,
  $ack_on_event_error                         = $facts['os_service_default'],
  $disable_non_metric_meters                  = $facts['os_service_default'],
  $workers                                    = $facts['os_service_default'],
  $messaging_urls                             = $facts['os_service_default'],
  $batch_size                                 = $facts['os_service_default'],
  $batch_timeout                              = $facts['os_service_default'],
  $package_ensure                             = 'present',
  Boolean $manage_event_pipeline              = false,
  Optional[Hash] $event_pipeline_config       = undef,
  Array[String[1]] $event_pipeline_publishers = ['gnocchi://'],
  $event_pipeline_cfg_file                    = $facts['os_service_default'],
  Boolean $manage_pipeline                    = false,
  Optional[Hash] $pipeline_config             = undef,
  Array[String[1]] $pipeline_publishers       = ['gnocchi://'],
  $pipeline_cfg_file                          = $facts['os_service_default'],
) {
  include ceilometer::deps
  include ceilometer::params

  package { 'ceilometer-notification':
    ensure => $package_ensure,
    name   => $ceilometer::params::agent_notification_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'ceilometer-agent-notification':
      ensure     => $service_ensure,
      name       => $ceilometer::params::agent_notification_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'ceilometer-service',
    }
  }

  if $manage_event_pipeline {
    if $event_pipeline_config {
      $event_pipeline_content = stdlib::to_yaml($event_pipeline_config)
    } else {
      $event_pipeline_content = template('ceilometer/event_pipeline.yaml.erb')
    }

    file { 'event_pipeline':
      ensure  => file,
      path    => $ceilometer::params::event_pipeline,
      content => $event_pipeline_content,
      mode    => '0640',
      owner   => 'root',
      group   => $ceilometer::params::group,
      tag     => 'ceilometer-yamls',
    }

    ceilometer_config {
      'DEFAULT/event_pipeline_cfg_file': value => $ceilometer::params::event_pipeline;
    }
  } else {
    ceilometer_config {
      'DEFAULT/event_pipeline_cfg_file': value => $event_pipeline_cfg_file;
    }
  }

  if $manage_pipeline {
    if $pipeline_config {
      $pipeline_content = stdlib::to_yaml($pipeline_config)
    } else {
      $pipeline_content = template('ceilometer/pipeline.yaml.erb')
    }

    file { 'pipeline':
      ensure  => file,
      path    => $ceilometer::params::pipeline,
      content => $pipeline_content,
      mode    => '0640',
      owner   => 'root',
      group   => $ceilometer::params::group,
      tag     => 'ceilometer-yamls',
    }

    ceilometer_config {
      'DEFAULT/pipeline_cfg_file': value => $ceilometer::params::pipeline;
    }
  } else {
    ceilometer_config {
      'DEFAULT/pipeline_cfg_file': value => $pipeline_cfg_file;
    }
  }

  ceilometer_config {
    'notification/ack_on_event_error'       : value => $ack_on_event_error;
    'notification/disable_non_metric_meters': value => $disable_non_metric_meters;
    'notification/workers'                  : value => $workers;
    'notification/messaging_urls'           : value => $messaging_urls, secret => true;
    'notification/batch_size'               : value => $batch_size;
    'notification/batch_timeout'            : value => $batch_timeout;
  }
}
