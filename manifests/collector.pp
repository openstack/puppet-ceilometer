# Ceilometer::Collector class
#
#
class ceilometer::collector(
  $enabled = true,
) {

  include 'ceilometer::params'

  package { 'ceilometer-collector':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-collector':
    name       => $::ceilometer::params::collector_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => [Package['ceilometer-collector'], Class['ceilometer::db']],
    subscribe  => Exec['ceilometer-dbsync']
  }

  Ceilometer_config<||> ~> Service['ceilometer-collector']

}
