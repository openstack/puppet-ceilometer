class ceilometer::agent-compute(
  $keystone_password,
  $verbose = 'False',
  $debug = 'False',
  $rabbit_host = '127.0.0.1',
  $rabbit_port = 5672,
  $rabbit_userid = 'guest',
  $rabbit_password = '',
  $rabbit_virtualhost = '/',
  $database_connection = 'mysql://ceilometer:ceilometer@127.0.0.1/ceilometer',
  $keystone_host = '127.0.0.1',
  $keystone_port = '35357',
  $keystone_protocol = 'http',
  $keystone_user = 'ceilometer',
  $enabled = true,
) {

  package { 'ceilometer-agent-compute':
    ensure => installed
  }

  ceilometer_setting {
    'DEFAULT/rabbit_host': value => $rabbit_host;
    'DEFAULT/rabbit_port': value => $rabbit_port;
    'DEFAULT/rabbit_userid': value => $rabbit_userid;
    'DEFAULT/rabbit_password': value => $rabbit_password;
    'DEFAULT/rabbit_virtualhost': value => $rabbit_virtualhost;
    'DEFAULT/debug': value => $debug;
    'DEFAULT/verbose': value => $verbose;
    'DEFAULT/database_connection': value => $database_connection;
    'keystone_authtoken/auth_host': value => $keystone_host;
    'keystone_authtoken/auth_port': value => $keystone_port;
    'keystone_authtoken/protocol': value => $keystone_protocol;
  }

  file { ['/etc/ceilometer/ceilometer.conf']:
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-agent-compute':
    name	=> $::ceilometer::params::agent_compute_package_name
    enable      => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }

}
