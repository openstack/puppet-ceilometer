ceilometer
==========

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

** 3.0.0 **

* Initial release of the puppet-ceilometer module.
