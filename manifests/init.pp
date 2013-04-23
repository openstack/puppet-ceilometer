# Class ceilometer
#
#  ceilometer base package & configuration
#
# == parameters
#  [*metering_secret*]
#    secret key for signing messages. Mandatory.
#  [*package_ensure*]
#    ensure state for package. Optional. Defaults to 'present'
#  [*verbose*]
#    should the daemons log verbose messages. Optional. Defaults to 'False'
#  [*debug*]
#    should the daemons log debug messages. Optional. Defaults to 'False'
#  [*rabbit_host*]
#    ip or hostname of the rabbit server. Optional. Defaults to '127.0.0.1'
#  [*rabbit_port*]
#    port of the rabbit server. Optional. Defaults to 5672.
#  [*rabbit_hosts*]
#    array of host:port (used with HA queues). Optional. Defaults to undef.
#    If defined, will remove rabbit_host & rabbit_port parameters from config
#  [*rabbit_userid*]
#    user to connect to the rabbit server. Optional. Defaults to 'guest'
#  [*rabbit_password*]
#    password to connect to the rabbit_server. Optional. Defaults to empty.
#  [*rabbit_virtualhost*]
#    virtualhost to use. Optional. Defaults to '/'
#
class ceilometer(
  $metering_secret    = false,
  $package_ensure     = 'present',
  $verbose            = 'False',
  $debug              = 'False',
  $rabbit_host        = '127.0.0.1',
  $rabbit_port        = 5672,
  $rabbit_hosts       = undef,
  $rabbit_userid      = 'guest',
  $rabbit_password    = '',
  $rabbit_virtualhost = '/',
) {

  validate_string($metering_secret)

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
    ceilometer_config { 'DEFAULT/rabbit_host': ensure => absent }
    ceilometer_config { 'DEFAULT/rabbit_port': ensure => absent }
    ceilometer_config { 'DEFAULT/rabbit_hosts':
      value => join($rabbit_hosts, ',')
    }
  } else {
    ceilometer_config { 'DEFAULT/rabbit_host': value => $rabbit_host }
    ceilometer_config { 'DEFAULT/rabbit_port': value => $rabbit_port }
    ceilometer_config { 'DEFAULT/rabbit_hosts':
      value => "${rabbit_host}:${rabbit_port}"
    }
  }

  if size($rabbit_hosts) > 1 {
    ceilometer_config { 'DEFAULT/rabbit_ha_queues': value => true }
  } else {
    ceilometer_config { 'DEFAULT/rabbit_ha_queues': value => false }
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
    'DEFAULT/notification_topics'    :
      value => 'notifications,glance_notifications';
  }

}
