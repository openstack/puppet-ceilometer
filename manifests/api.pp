class ceilometer::api(
  $enabled = true,
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
  }

}
