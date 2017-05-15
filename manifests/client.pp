# == Class: ceilometer::client
#
# Installs the ceilometer python library.
#
# === Parameters:
#
# [*ensure*]
#   (Optional) Ensure state for pachage.
#   Defaults to 'present'.
#
class ceilometer::client (
  $ensure = 'present'
) {

  include ::ceilometer::deps
  include ::ceilometer::params

  warning('This class is deprecated and will be removed in future releases.
           Use gnocchi, aodh or panko clients to access data instead.')

  package { 'python-ceilometerclient':
    ensure => $ensure,
    name   => $::ceilometer::params::client_package_name,
    tag    => 'openstack',
  }

}

