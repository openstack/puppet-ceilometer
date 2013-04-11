#
class ceilometer (
  $metering_secret,
  $package_ensure     = 'present',
  $verbose            = 'False',
  $debug              = 'False',
  $rabbit_host        = '127.0.0.1',
  $rabbit_hosts       = undef,
  $rabbit_port        = 5672,
  $rabbit_userid      = 'guest',
  $rabbit_password    = '',
  $rabbit_virtualhost = '/',
) {

  include ceilometer::params

  File {
    require => Package['ceilometer-common'],
  }

  group { 'ceilometer':
    name    => 'ceilometer',
    require => Package['ceilometer-common'],
  }

  user { 'ceilometer':
    name    => 'ceilometer',
    gid     => 'ceilometer',
    groups  => ['nova'],
    system  => true,
    require => Package['ceilometer-common'],
  }

  file { '/etc/ceilometer/':
    ensure  => directory,
    owner   => 'ceilometer',
    group   => 'ceilometer',
    mode    => '0750',
  }

  file { '/etc/ceilometer/ceilometer.conf':
    owner   => 'ceilometer',
    group   => 'ceilometer',
    mode    => '0640',
  }

  package { 'ceilometer-common':
    ensure => $package_ensure,
    name   => $::ceilometer::params::common_package_name,
  }

  Package['ceilometer-common'] -> Ceilometer_config<||>

  if $rabbit_hosts {
    ceilometer_config { 'DEFAULT/rabbit_hosts': value => join($rabbit_hosts, ',') }
  } else {
    ceilometer_config { 'DEFAULT/rabbit_host': value => $rabbit_host }
    ceilometer_config { 'DEFAULT/rabbit_port': value => $rabbit_port }
    ceilometer_config { 'DEFAULT/rabbit_hosts': value => "${rabbit_host}:${rabbit_port}" }
  }

  if size($rabbit_hosts) > 1 {
    ceilometer_config { 'DEFAULT/rabbit_ha_queues': value => 'true' }
  } else {
    ceilometer_config { 'DEFAULT/rabbit_ha_queues': value => 'false' }
  }

  ceilometer_config {
    'DEFAULT/metering_secret'        : value => $metering_secret;
    'DEFAULT/rabbit_userid'          : value => $rabbit_userid;
    'DEFAULT/rabbit_password'        : value => $rabbit_password;
    'DEFAULT/rabbit_virtualhost'     : value => $rabbit_virtualhost;
    'DEFAULT/debug'                  : value => $debug;
    'DEFAULT/verbose'                : value => $verbose;
    'DEFAULT/log_dir'                : value => $::ceilometer::params::log_dir;
    # Fix a bad default value in ceilometer.
    # Fixed in https: //review.openstack.org/#/c/18487/
    'DEFAULT/glance_control_exchange': value => 'glance';
    # Add glance-notifications topic.
    # Fixed in glance https://github.com/openstack/glance/commit/2e0734e077ae
    # Fix will be included in Grizzly
    'DEFAULT/notification_topics'    : value => 'notifications,glance_notifications';
  }

}
