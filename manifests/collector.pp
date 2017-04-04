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
# [*meter_dispatchers*]
#   (Optional) dispatcher driver(s) to process meter data.
#   Can be an array or a string.
#   Defaults to $::os_service_default.
#
# [*event_dispatchers*]
#   (Optional) dispatcher driver(s) to process event data.
#   Can be an array or a string.
#   Defaults to $::os_service_default.
#
# [*collector_workers*]
#   (Optional) Number of workers for collector service (integer value).
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*meter_dispatcher*]
#   (Optional) dispatcher driver(s) to process meter data.
#   Can be an array or a string.
#   Defaults to undef.
#
# [*event_dispatcher*]
#   (Optional) dispatcher driver(s) to process event data.
#   Can be an array or a string.
#   Defaults to undef.
#
class ceilometer::collector (
  $manage_service    = true,
  $enabled           = true,
  $package_ensure    = 'present',
  $udp_address       = '0.0.0.0',
  $udp_port          = '4952',
  $collector_workers = $::os_service_default,
  $meter_dispatchers = $::os_service_default,
  $event_dispatchers = $::os_service_default,
  # DEPRECATED PARAMETERS
  $meter_dispatcher  = undef,
  $event_dispatcher  = undef,
) {

  include ::ceilometer::deps
  include ::ceilometer::params

  warning('This class is deprecated. Now the pipeline.yaml can be configured directly to send data eg: gnocchi://')

  # We accept udp_address to be set to empty instead of the usual undef to stay
  # close to the "strange" upstream interface.
  if (is_ip_address($udp_address) != true and $udp_address != '' ){
    fail("${udp_address} is not a valid ip and is not empty")
  }

  if $meter_dispatcher {
    warning('The meter_dispatcher parameter is deprecated, please use meter_dispatchers instead.')
    $meter_dispatchers_real = $meter_dispatcher
  } else {
    $meter_dispatchers_real = $meter_dispatchers
  }

  if $event_dispatcher {
    warning('The event_dispatcher parameter is deprecated, please use event_dispatchers instead.')
    $event_dispatchers_real = $event_dispatcher
  } else {
    $event_dispatchers_real = $event_dispatchers
  }

  ceilometer_config {
    'collector/udp_address':     value => $udp_address;
    'collector/udp_port':        value => $udp_port;
    'collector/workers':         value => $collector_workers;
    'DEFAULT/meter_dispatchers': value => any2array($meter_dispatchers_real);
    'DEFAULT/event_dispatchers': value => any2array($event_dispatchers_real);
  }

  ensure_resource( 'package', [$::ceilometer::params::collector_package_name],
    {
      ensure => $package_ensure,
      tag    => ['openstack', 'ceilometer-package']
    }
  )

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'ceilometer-collector':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::collector_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'ceilometer-service'
  }
}
