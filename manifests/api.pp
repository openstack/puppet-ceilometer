# Installs & configure the ceilometer api service
#
# == Parameters
#
#  [*enabled*]
#    (optional) Should the service be enabled.
#    Defaults to true
#
#  [*manage_service*]
#    (optional) Whether the service should be managed by Puppet.
#    Defaults to true.
#
# [*keystone_user*]
#   (optional) The name of the auth user
#   Defaults to ceilometer
#
#  [*keytone_user*]
#    (optional) User to authenticate with.
#    Defaults to 'ceilometer'.
#
#  [*keystone_tenant*]
#    (optional) Tenant to authenticate with.
#    Defaults to 'services'.
#
#  [*keystone_password*]
#    Password to authenticate with.
#    Mandatory.
#
# [*keystone_auth_uri*]
#   (optional) Public Identity API endpoint.
#   Defaults to 'http://127.0.0.1:5000/'.
#
# [*keystone_identity_uri*]
#   (optional) Complete admin Identity API endpoint.
#   Defaults to: 'http://127.0.0.1:35357/'
#
#  [*host*]
#    (optional) The ceilometer api bind address.
#    Defaults to 0.0.0.0
#
#  [*port*]
#    (optional) The ceilometer api port.
#    Defaults to 8777
#
#  [*package_ensure*]
#    (optional) ensure state for package.
#    Defaults to 'present'
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of ceilometer-api.
#   If the value is 'httpd', this means ceilometer-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'ceilometer::wsgi::apache'...}
#   to make ceilometer-api be a web app using apache mod_wsgi.
#   Defaults to '$::ceilometer::params::api_service_name'
#
# [*api_workers*]
#   (optional) Number of workers for Ceilometer API server (integer value).
#   Defaults to $::os_service_default
#
class ceilometer::api (
  $manage_service             = true,
  $enabled                    = true,
  $package_ensure             = 'present',
  $keystone_user              = 'ceilometer',
  $keystone_tenant            = 'services',
  $keystone_password          = false,
  $keystone_auth_uri          = 'http://127.0.0.1:5000/',
  $keystone_identity_uri      = 'http://127.0.0.1:35357/',
  $host                       = '0.0.0.0',
  $port                       = '8777',
  $service_name               = $::ceilometer::params::api_service_name,
  $api_workers                = $::os_service_default,
) inherits ceilometer::params {

  include ::ceilometer::params
  include ::ceilometer::policy

  validate_string($keystone_password)

  Ceilometer_config<||> ~> Service[$service_name]
  Class['ceilometer::policy'] ~> Service[$service_name]

  Package['ceilometer-api'] -> Service[$service_name]
  Package['ceilometer-api'] -> Class['ceilometer::policy']
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

  Package['ceilometer-common'] -> Service[$service_name]

  if $service_name == $::ceilometer::params::api_service_name {
    service { 'ceilometer-api':
      ensure     => $service_ensure,
      name       => $::ceilometer::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      require    => Class['ceilometer::db'],
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
    Class['ceilometer::db'] -> Service[$service_name]

    # we need to make sure ceilometer-api/eventlet is stopped before trying to start apache
    Service['ceilometer-api'] -> Service[$service_name]
  } else {
    fail('Invalid service_name. Either ceilometer/openstack-ceilometer-api for running as a standalone service, or httpd for being run by a httpd server')
  }

  ceilometer_config {
    'DEFAULT/api_workers'                  : value => $api_workers;
    'keystone_authtoken/admin_tenant_name' : value => $keystone_tenant;
    'keystone_authtoken/admin_user'        : value => $keystone_user;
    'keystone_authtoken/admin_password'    : value => $keystone_password, secret => true;
    'api/host'                             : value => $host;
    'api/port'                             : value => $port;
  }

  ceilometer_config {
    'keystone_authtoken/auth_uri'     : value => $keystone_auth_uri;
    'keystone_authtoken/identity_uri' : value => $keystone_identity_uri;
  }

}
