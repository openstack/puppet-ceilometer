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

  include ::ceilometer::params

  package { 'python-ceilometerclient':
    ensure => $ensure,
    name   => $::ceilometer::params::client_package_name,
    tag    => 'openstack',
  }

}

