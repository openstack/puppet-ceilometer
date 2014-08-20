# Installs the ceilometer collector service
#
# == Params
#  [*enabled*]
#    (optional) Should the service be enabled.
#    Defaults to true.
#
#  [*manage_service*]
#    (optional)  Whether the service should be managed by Puppet.
#    Defaults to true.
#
class ceilometer::collector (
  $manage_service = true,
  $enabled        = true,
) {

  include ceilometer::params

  Ceilometer_config<||> ~> Service['ceilometer-collector']

  Package[$::ceilometer::params::collector_package_name] -> Service['ceilometer-collector']
  ensure_packages([$::ceilometer::params::collector_package_name])

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
      Class['ceilometer::db'] -> Service['ceilometer-collector']
      Exec['ceilometer-dbsync'] ~> Service['ceilometer-collector']
    } else {
      $service_ensure = 'stopped'
    }
  }

  Package['ceilometer-common'] -> Service['ceilometer-collector']
  service { 'ceilometer-collector':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::collector_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true
  }
}
