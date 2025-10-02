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
# [*manage_backend_package*]
#   (Optional) Whether to install the backend package.
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'
#
class ceilometer::coordination (
  $backend_url                            = $facts['os_service_default'],
  Boolean $manage_backend_package         = true,
  Stdlib::Ensure::Package $package_ensure = present,
) {
  include ceilometer::deps

  oslo::coordination { 'ceilometer_config':
    backend_url            => $backend_url,
    manage_backend_package => $manage_backend_package,
    package_ensure         => $package_ensure,
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['ceilometer_config'] -> Anchor['ceilometer::service::begin']
}
