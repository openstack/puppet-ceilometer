# == Class: ceilometer::api
#
# Installs & configure the Ceilometer api service
#
# === Parameters
#
# [*enabled*]
#   (Optional) Should the service be enabled.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*host*]
#   (Optional) The ceilometer api bind address.
#   Defaults to '0.0.0.0'.
#
# [*port*]
#   (Optional) The ceilometer api port.
#   Defaults to 8777.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'.
#
# [*service_name*]
#   (Optional) Name of the service that will be providing the
#   server functionality of ceilometer-api.
#   If the value is 'httpd', this means ceilometer-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'ceilometer::wsgi::apache'...}
#   to make ceilometer-api be a web app using apache mod_wsgi.
#   Defaults to '$::ceilometer::params::api_service_name'.
#
# [*api_workers*]
#   (Optional) Number of workers for Ceilometer API server (integer value).
#   Defaults to $::os_service_default.
#
# [*auth_strategy*]
#   (Optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
class ceilometer::api (
  $manage_service               = true,
  $enabled                      = true,
  $package_ensure               = 'present',
  $host                         = '0.0.0.0',
  $port                         = '8777',
  $service_name                 = $::ceilometer::params::api_service_name,
  $api_workers                  = $::os_service_default,
  $auth_strategy                = 'keystone',
  $enable_proxy_headers_parsing = $::os_service_default,
) inherits ceilometer::params {

  include ::ceilometer::deps
  include ::ceilometer::params
  include ::ceilometer::policy

  if $auth_strategy == 'keystone' {
    include ::ceilometer::keystone::authtoken
  }

  package { 'ceilometer-api':
    ensure => $package_ensure,
    name   => $::ceilometer::params::api_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  if $service_name == $::ceilometer::params::api_service_name {
    service { 'ceilometer-api':
      ensure     => $service_ensure,
      name       => $::ceilometer::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'ceilometer-service',
    }
  } elsif $service_name == 'httpd' {
    include ::apache::params
    service { 'ceilometer-api':
      ensure => 'stopped',
      name   => $::ceilometer::params::api_service_name,
      enable => false,
      tag    => 'ceilometer-service',
    }

    # we need to make sure ceilometer-api/eventlet is stopped before trying to start apache
    Service['ceilometer-api'] -> Service[$service_name]
  } else {
    fail("Invalid service_name. Either ceilometer/openstack-ceilometer-api for \
running as a standalone service, or httpd for being run by a httpd server")
  }

  ceilometer_config {
    'api/workers': value => $api_workers;
    'api/host':    value => $host;
    'api/port':    value => $port;
  }

  oslo::middleware { 'ceilometer_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }

}
