#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
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
# == Class: ceilometer::expirer
#
# Setups Ceilometer Expirer service to enable TTL feature.
#
# === Parameters
#
#  [*enable_cron*]
#    (optional) Whether to configure a crontab entry to run the expiry.
#    Defaults to true.
#
#  [*minute*]
#    (optional) Defaults to '1'.
#
#  [*hour*]
#    (optional) Defaults to '0'.
#
#  [*monthday*]
#    (optional) Defaults to '*'.
#
#  [*month*]
#    (optional) Defaults to '*'.
#
#  [*weekday*]
#    (optional) Defaults to '*'.
#

class ceilometer::expirer (
  $enable_cron = true,
  $minute      = 1,
  $hour        = 0,
  $monthday    = '*',
  $month       = '*',
  $weekday     = '*',
) {

  include ::ceilometer::params

  Package<| title == 'ceilometer-common' |> -> Class['ceilometer::expirer']

  if $enable_cron {
    cron { 'ceilometer-expirer':
      command     => $ceilometer::params::expirer_command,
      environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
      user        => 'ceilometer',
      minute      => $minute,
      hour        => $hour,
      monthday    => $monthday,
      month       => $month,
      weekday     => $weekday
    }
  }

}
