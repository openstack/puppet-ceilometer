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
# Unit tests for ceilometer::expirer
#

require 'spec_helper'

describe 'ceilometer::expirer' do

  let :pre_condition do
    "class { 'ceilometer': telemetry_secret => 's3cr3t' }"
  end

  let :params do
    {}
  end

  shared_examples_for 'ceilometer-expirer' do

    it { is_expected.to contain_class('ceilometer::deps') }
    it { is_expected.to contain_class('ceilometer::params') }

    it 'installs ceilometer common package' do
      is_expected.to contain_package('ceilometer-common').with(
        :ensure => 'present',
        :name   => platform_params[:common_package_name]
      )
    end

    it 'configures a cron' do
      is_expected.to contain_cron('ceilometer-expirer').with(
        :ensure      => 'present',
        :command     => 'ceilometer-expirer',
        :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
        :user        => 'ceilometer',
        :minute      => 1,
        :hour        => 0,
        :monthday    => '*',
        :month       => '*',
        :weekday     => '*'
      )
    end

    context 'with cron not enabled' do
      before do
        params.merge!({
          :enable_cron => false })
      end
      it {
        is_expected.to contain_cron('ceilometer-expirer').with(
          :ensure      => 'absent',
          :command     => 'ceilometer-expirer',
          :environment => 'PATH=/bin:/usr/bin:/usr/sbin SHELL=/bin/sh',
          :user        => 'ceilometer',
          :minute      => 1,
          :hour        => 0,
          :monthday    => '*',
          :month       => '*',
          :weekday     => '*'
        )
      }
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
          { :common_package_name => 'ceilometer-common' }
        when 'RedHat'
          { :common_package_name => 'openstack-ceilometer-common' }
        end
      end

      it_behaves_like 'ceilometer-expirer'
    end
  end

end
