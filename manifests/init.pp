#
# == parameters
#   * package_ensure - ensure state for package.
#
class ceilometer(
  $package_ensure = 'present'
) {

  include ceilometer::params

  file { '/etc/ceilometer/':
    ensure  => directory,
    owner   => 'ceilometer',
    group   => 'root',
    mode    => '0770',
    require => Package['ceilometer']
  }
  package { 'ceilometer-common':
    name   => $::ceilometer::params::common_package_name,
    ensure => $package_ensure,
  }
}

