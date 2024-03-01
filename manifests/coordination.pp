# == Class: ceilometer::coordination
#
# Setup and configure Ceilometer coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
class ceilometer::coordination (
  $backend_url    = $facts['os_service_default'],
) {

  include ceilometer::deps

  oslo::coordination{ 'ceilometer_config':
    backend_url => $backend_url
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['ceilometer_config'] -> Anchor['ceilometer::service::begin']
}
