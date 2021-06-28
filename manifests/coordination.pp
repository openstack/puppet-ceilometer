# == Class: ceilometer::coordination
#
# Setup and configure Ceilometer coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $::os_service_default
#
class ceilometer::coordination (
  $backend_url    = $::os_service_default,
) {

  include ceilometer::deps

  $backend_url_real = pick($::ceilometer::agent::polling::coordination_url, $backend_url)

  oslo::coordination{ 'ceilometer_config':
    backend_url => $backend_url_real
  }
}
