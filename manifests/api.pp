class ceilometer::api(
  $enabled = true,
  $keystone_host = '127.0.0.1',
  $keystone_port = '35357',
  $keystone_protocol = 'http',
  $keystone_user = 'ceilometer',
  $keystone_password,
) {

  package { 'ceilometer-api':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-api':
    name	=> $::ceilometer::params::api_service_name
    enable      => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require => Package['ceilometer-api']
  }

}
