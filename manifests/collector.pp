# == Class: ceilometer::params
#
# Installs the ceilometer collector service
#
# === Parameters:
#
# [*enabled*]
#   (Optional) Should the service be enabled.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional)  Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'.
#
# [*udp_address*]
#   (Optional) the ceilometer collector udp bind address.
#   Set it empty to disable the collector listener.
#   Defaults to '0.0.0.0'.
#
# [*udp_port*]
#   (Optional) the ceilometer collector udp bind port.
#   Defaults to '4952'.
#
# [*meter_dispatcher*]
#   (Optional) dispatcher driver(s) to process meter data.
#   Can be an array or a string.
#   Defaults to 'database'.
#
# [*event_dispatcher*]
#   (Optional) dispatcher driver(s) to process event data.
#   Can be an array or a string.
#   Defaults to 'database'.
#
# [*collector_workers*]
#   (Optional) Number of workers for collector service (integer value).
#   Defaults to $::os_service_default.
#
class ceilometer::collector (
  $manage_service    = true,
  $enabled           = true,
  $package_ensure    = 'present',
  $udp_address       = '0.0.0.0',
  $udp_port          = '4952',
  $collector_workers = $::os_service_default,
  $meter_dispatcher  = 'database',
  $event_dispatcher  = 'database',
) {

  include ::ceilometer::params

  Ceilometer_config<||> ~> Service['ceilometer-collector']

  # We accept udp_address to be set to empty instead of the usual undef to stay
  # close to the "strange" upstream interface.
  if (is_ip_address($udp_address) != true and $udp_address != '' ){
    fail("${udp_address} is not a valid ip and is not empty")
  }

  ceilometer_config {
    'collector/udp_address':     value => $udp_address;
    'collector/udp_port':        value => $udp_port;
    'collector/workers':         value => $collector_workers;
    'DEFAULT/meter_dispatchers':  value => join(any2array($meter_dispatcher), ',');
    'DEFAULT/event_dispatchers':  value => join(any2array($event_dispatcher), ',');
  }

  Package[$::ceilometer::params::collector_package_name] -> Service['ceilometer-collector']
  ensure_resource( 'package', [$::ceilometer::params::collector_package_name],
    { ensure => $package_ensure }
  )

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
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
    hasrestart => true,
    tag        => 'ceilometer-service'
  }
}
