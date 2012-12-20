#
# == parameters
#   * package_ensure - ensure state for package.
#
class ceilometer(
  $metering_secret,
  $package_ensure     = 'present',
  $verbose            = 'False',
  $debug              = 'False',
  $rabbit_host        = '127.0.0.1',
  $rabbit_port        = 5672,
  $rabbit_userid      = 'guest',
  $rabbit_password    = '',
  $rabbit_virtualhost = '/',
) {

  include ceilometer::params

  group { 'ceilometer':
    name    => $::ceilometer::params::groupname,
    require => $::ceilometer::common_package_name,
  }

  user { 'ceilometer':
    name    => $::ceilometer::params::username,
    gid     => $::ceilometer::params::groupname,
    groups  => ['nova'],
    system  => true,
    require => [
      Group['ceilometer'],
      Package[$::ceilometer::params::common_package_name]
    ],
  }

  file { '/etc/ceilometer/':
    ensure  => directory,
    owner   => 'ceilometer',
    group   => 'ceilometer',
    mode    => '0750',
    require => [Package['ceilometer-common'], User['ceilometer']],
  }

  file { '/etc/ceilometer/ceilometer.conf':
    ensure  => file,
    owner   => 'ceilometer',
    group   => 'ceilometer',
    mode    => '0640',
    require => [File['/etc/ceilometer'], User['ceilometer']],
  }

  package { 'ceilometer-common':
    ensure => $package_ensure,
    name   => $::ceilometer::params::common_package_name,
  }

  Package['ceilometer-common'] -> Ceilometer_config<||>

  ceilometer_config {
    'DEFAULT/metering_secret'    : value => $metering_secret;
    'DEFAULT/rabbit_host'        : value => $rabbit_host;
    'DEFAULT/rabbit_port'        : value => $rabbit_port;
    'DEFAULT/rabbit_userid'      : value => $rabbit_userid;
    'DEFAULT/rabbit_password'    : value => $rabbit_password;
    'DEFAULT/rabbit_virtualhost' : value => $rabbit_virtualhost;
    'DEFAULT/debug'              : value => $debug;
    'DEFAULT/verbose'            : value => $verbose;
    'DEFAULT/log_dir'            : value => $::ceilometer::params::log_dir;
  }

}
