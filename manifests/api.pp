# Ceilometer::Api class
#
#
class ceilometer::api(
  $enabled           = true,
  $keystone_host     = '127.0.0.1',
  $keystone_port     = '35357',
  $keystone_protocol = 'http',
  $keystone_user     = 'ceilometer',
  $keystone_password = false,
) {

  include 'ceilometer::params'

  validate_string($keystone_password)

  package { 'ceilometer-api':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-api':
    name       => $::ceilometer::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => [Package['ceilometer-api'], Class['ceilometer::db']],
    subscribe  => Exec['ceilometer-dbsync']
  }

  Ceilometer_config<||> ~> Service['ceilometer-api']

  ceilometer_config {
    'keystone_authtoken/auth_host'         : value => $keystone_host;
    'keystone_authtoken/auth_port'         : value => $keystone_port;
    'keystone_authtoken/protocol'          : value => $keystone_protocol;
    'keystone_authtoken/admin_tenant_name' : value => 'services';
    'keystone_authtoken/admin_user'        : value => $keystone_user;
    'keystone_authtoken/admin_password'    : value => $keystone_password;
  }
}
