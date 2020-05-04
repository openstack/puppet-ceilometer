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
# DEPRECATED!
# Setups Ceilometer Expirer service to enable TTL feature.
#
# === Parameters
#
#  [*enable_cron*]
#    (optional) Whether to configure a crontab entry to run the expiry.
#    When set to False, Puppet will try to remove the crontab.
#    It's useful when we upgrade from Ocata to Pike and want to remove it.
#    Defaults to undef.
#
#  [*minute*]
#    (optional) Defaults to undef.
#
#  [*hour*]
#    (optional) Defaults to undef.
#
#  [*monthday*]
#    (optional) Defaults to undef.
#
#  [*month*]
#    (optional) Defaults to undef.
#
#  [*weekday*]
#    (optional) Defaults to undef.
#
class ceilometer::expirer (
  $enable_cron = undef,
  $minute      = undef,
  $hour        = undef,
  $monthday    = undef,
  $month       = undef,
  $weekday     = undef,
) {
  warning('The ceilometer::expirer class is deprecated and has no effect')
}
