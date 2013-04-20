#
class ceilometer::api (
  $enabled           = true,
  $keystone_host     = '127.0.0.1',
  $keystone_port     = '35357',
  $keystone_protocol = 'http',
  $keystone_user     = 'ceilometer',
  $keystone_tenant   = 'services',
  $keystone_password = false,
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

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
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
    'keystone_authtoken/admin_password'    : value => $keystone_password;
  }
}
