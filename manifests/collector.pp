#
class ceilometer::collector (
  $enabled = true,
) {

  include ceilometer::params

  Package<| title == 'ceilometer-common' |> -> Class['ceilometer::collector']

  package { 'ceilometer-collector':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-collector':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::collector_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => [Package['ceilometer-collector'], Class['ceilometer::db']],
    subscribe  => Exec['ceilometer-dbsync']
  }

  Ceilometer_config<||> ~> Service['ceilometer-collector']
}
