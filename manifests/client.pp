#
# Installs the ceilometer python library.
#
# == parameters
#  * ensure - ensure state for pachage.
#
class ceilometer::client (
  $ensure = 'present'
) {

  package { 'python-ceilometer':
    name   => $::ceilometer::params::client_package_name,
    ensure => $ensure,
  }

}

