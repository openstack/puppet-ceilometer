class ceilometer::collector(
  $enabled = true,
) {

  package { 'ceilometer-collector':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-collector':
    name	=> $::ceilometer::params::collector_service_name
    enable      => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }

}
