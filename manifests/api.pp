# Installs & configure the ceilometer api service
#
# == Parameters
#  [*enabled*]
#    (optional) Should the service be enabled.
#    Defaults to true
#
#  [*manage_service*]
#    (optional) Whether the service should be managed by Puppet.
#    Defaults to true.
#
#  [*keystone_host*]
#    (optional) Keystone's admin endpoint IP/Host.
#    Defaults to '127.0.0.1'
#
#  [*keystone_port*]
#    (optional) Keystone's admin endpoint port.
#    Defaults to 35357
#
#  [*keystone_auth_admin_prefix*]
#    (optional) 'path' to the keystone admin endpoint.
#    Define to a path starting with a '/' and without trailing '/'.
#    Eg.: '/keystone/admin' to match keystone::wsgi::apache default.
#    Defaults to false (empty)
#
#  [*keystone_protocol*]
#    (optional) 'http' or 'https'
#    Defaults to 'https'.
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
#  [*host*]
#    (optional) The ceilometer api bind address.
#    Defaults to 0.0.0.0
#
#  [*port*]
#    (optional) The ceilometer api port.
#    Defaults to 8777
#

class ceilometer::api (
  $manage_service             = true,
  $enabled                    = true,
  $keystone_host              = '127.0.0.1',
  $keystone_port              = '35357',
  $keystone_auth_admin_prefix = false,
  $keystone_protocol          = 'http',
  $keystone_user              = 'ceilometer',
  $keystone_tenant            = 'services',
  $keystone_password          = false,
  $keystone_auth_uri          = false,
  $host                       = '0.0.0.0',
  $port                       = '8777'
) {

  include ceilometer::params

  validate_string($keystone_password)

  Ceilometer_config<||> ~> Service['ceilometer-api']

  Package['ceilometer-api'] -> Ceilometer_config<||>
  Package['ceilometer-api'] -> Service['ceilometer-api']
  package { 'ceilometer-api':
    ensure => installed,
    name   => $::ceilometer::params::api_package_name,
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  Package['ceilometer-common'] -> Service['ceilometer-api']
  service { 'ceilometer-api':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['ceilometer::db'],
    subscribe  => Exec['ceilometer-dbsync']
  }

  ceilometer_config {
    'keystone_authtoken/auth_host'         : value => $keystone_host;
    'keystone_authtoken/auth_port'         : value => $keystone_port;
    'keystone_authtoken/auth_protocol'     : value => $keystone_protocol;
    'keystone_authtoken/admin_tenant_name' : value => $keystone_tenant;
    'keystone_authtoken/admin_user'        : value => $keystone_user;
    'keystone_authtoken/admin_password'    : value => $keystone_password, secret => true;
    'api/host'                             : value => $host;
    'api/port'                             : value => $port;
  }

  if $keystone_auth_admin_prefix {
    validate_re($keystone_auth_admin_prefix, '^(/.+[^/])?$')
    ceilometer_config {
      'keystone_authtoken/auth_admin_prefix': value => $keystone_auth_admin_prefix;
    }
  } else {
    ceilometer_config {
      'keystone_authtoken/auth_admin_prefix': ensure => absent;
    }
  }

  if $keystone_auth_uri {
    ceilometer_config {
      'keystone_authtoken/auth_uri': value => $keystone_auth_uri;
    }
  } else {
    ceilometer_config {
      'keystone_authtoken/auth_uri': value => "${keystone_protocol}://${keystone_host}:5000/";
    }
  }

}
