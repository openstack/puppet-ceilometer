Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/puppet-ceilometer.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

Ceilometer
==========

#### Table of Contents

1. [Overview - What is the ceilometer module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with ceilometer](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)

Overview
--------

The ceilometer module is part of [OpenStack](https://github.com/openstack), an effort by the
OpenStack infrastructure team to provice continuous integration testing and code review for
OpenStack and OpenStack community projects as part of the core software. The module itself
is used to flexibly configure and manage the metering service for OpenStack.

Module Description
------------------

The ceilometer module is an attempt to make Puppet capable of managing the entirety of ceilometer.
This includes manifests to provision the ceilometer api, agents, and database stores. A
ceilometer_config type is supplied to assist in the manipulation of configuration files.

Setup
-----

**What the ceilometer module affects**

* [Ceilometer](https://wiki.openstack.org/wiki/Ceilometer), the metering service for OpenStack

### Installing ceilometer

    puppet module install openstack/ceilometer

### Beginning with ceilometer

To utilize the ceilometer module's functionality you will need to declare multiple resources. This is not an exhaustive list of all the components needed. We recommend that you consult and understand the [core openstack](https://docs.openstack.org) documentation to assist you in understanding the available deployment options.

```puppet
class { '::ceilometer':
  telemetry_secret      => 'secrete',
  default_transport_url => 'rabbit://ceilometer:an_even_bigger_secret@127.0.0.1:5672',
}
class { '::ceilometer::keystone::auth':
  password => 'a_big_secret',
}
class { '::ceilometer::collector': }
class { '::ceilometer::expirer': }
class { '::ceilometer::agent::polling': }
class { '::ceilometer::agent::notification': }
class { '::ceilometer::db': }
class { '::ceilometer::keystone::authtoken':
  password => 'a_big_secret',
  auth_url => 'http://127.0.0.1:35357/',
}
```

Implementation
--------------

### ceilometer

ceilometer is a combination of Puppet manifests and Ruby code to deliver configuration and
extra functionality through types and providers.

### Types

#### ceilometer_config

The `ceilometer_config` provider is a children of the ini_setting provider. It allows one to write an entry in the `/etc/ceilometer/ceilometer.conf` file.

```puppet
ceilometer_config { 'DEFAULT/http_timeout' :
  value => 600,
}
```

This will write `http_timeout=600` in the `[DEFAULT]` section.

##### name

Section/setting name to manage from `ceilometer.conf`

##### value

The value of the setting to be defined.

##### secret

Whether to hide the value from Puppet logs. Defaults to `false`.

##### ensure_absent_val

If value is equal to ensure_absent_val then the resource will behave as if `ensure => absent` was specified. Defaults to `<SERVICE DEFAULT>`

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

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-ceilometer/graphs/contributors

This is the ceilometer module.
