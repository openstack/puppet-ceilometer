Ceilometer
==========

5.0.0 - 2014.2.0 - Juno

#### Table of Contents

1. [Overview - What is the ceilometer module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with ceilometer](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)
8. [Release Notes - Notes on the most recent updates to the module](#release-notes)

Overview
--------

The ceilometer module is part of [Stackforge](https://github.com/stackforge), an effort by the
OpenStack infrastructure team to provice continuous integration testing and code review for
OpenStack and OpenStack community projects not part of the core software. The module itself
is used to flexibly configure and manage the metering service for OpenStack.

Module Description
------------------

The ceilometer module is an attempt to make Puppet capable of managing the entirety of ceilometer.
This includes manifests to provision the ceilometer api, agents, and database stores. A
ceilometer_config type is supplied to assist in the manipulation of configuration files.

Setup
-----

**What the ceilometer module affects**

* ceilometer, the metering service for OpenStack

### Installing ceilometer

  example% puppet module install puppetlabs/ceilometer

### Beginning with ceilometer

Implementation
--------------

### ceilometer

ceilometer is a combination of Puppet manifests and Ruby code to deliver configuration and
extra functionality through types and providers.

Limitations
-----------

* The ceilometer modules have only been tested on RedHat and Ubuntu family systems.

Beaker-Rspec
------------

This module has beaker-rspec tests

To run:

``shell
bundle install
bundle exec rspec spec/acceptance
``

Development
-----------

Developer documentation for the entire puppet-openstack project

* https://wiki.openstack.org/wiki/Puppet-openstack#Developer_documentation

Contributors
------------

* https://github.com/stackforge/puppet-ceilometer/graphs/contributors

This is the ceilometer module.

Release Notes
-------------

** 5.0.0 **
* Stable Juno release
* Added package_ensure parameters to various classes to control package installation
* Added ceilometer::policy to control policy.json
* Updated validate_re expressions for Puppet 3.7
* Bumped stdlib dependency to >=4.0.0
* Added manage_service parameters to various classes to control whether the service was managed, as well as added enabled parameters where not already present
* Added parameters to control whether to configure keystone users
* Added the ability to override the keystone service name in ceilometer::keystone::auth
* Migrated the ceilometer::db::mysql class to use openstacklib::db::mysql and deprecated the mysql_module parameter
* Fixed ceilometer-notification package name for RHEL
* Removed deprecation notices for sectionless ceilometer_config types for Juno release
* Added ability to hide secrets from puppet logs

** 4.2.0 **

* Fixed dependency on nova-common package
* Added new class for extended logging options
* Fixed ssl parameter requirements for kombu and rabbit
* Fixed mysql_grant call
* Fixed ceilometer-collecter service relationships when service is disabled


** 4.1.0 **

* Added RabbitMQ SSL Support.
* Fixed dependency cycle bug.
* Fixed agent_notification_service_name.
* Changed default mysql charset to UTF8.
* Pinned major gems.

** 4.0.0 **

* Stable Icehouse release.
* Added ability to override notification topics.
* Implemented notification agent service.
* Fixed region name configuration.
* Fixed ensure packages bug.
* Added support for puppetlabs-mysql 2.2 and greater.
* Introduced ceilometer::config to handle additional custom options.

** 3.1.1 **

* Removed enforcement of glance_control_exchange.
* Fixed user reference in db.pp.
* Allow db fields configuration without need for dbsync for better replicaset support.
* Fixed alarm package parameters Debian/Ubuntu.


** 3.1.0 **

* Fixed package ceilometer-alarm type error on Debian.
* Remove log_dir from params and make logs configurable in init.
* Removed glance_notifications from notification_topic.
* Don't match commented [DEFAULT] section.

** 3.0.0 **

* Initial release of the puppet-ceilometer module.


License
--------

Apache License 2.0

   Copyright 2012 eNovance <licensing@enovance.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

Contact
-------

techs@enovance.com
