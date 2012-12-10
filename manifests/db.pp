# Ceilometer::Db::Settings class
#
#
class ceilometer::db (
  $database_connection = 'mysql://ceilometer:ceilometer@127.0.0.1/ceilometer'
) {

  include 'ceilometer::params'

  validate_re($database_connection,
    '(sqlite|mysql|posgres|mongodb):\/\/(\S+:\S+@\S+\/\S+)?')

  case $database_connection {
    /^mysql:\/\//: {
      $backend_package = false
      include mysql::python
    }
    /^postgres:\/\//: {
      $backend_package = 'python-psycopg2'
    }
    /^mongodb:\/\//: {
      $backend_package = 'python-pymongo'
    }
    /^sqlite:\/\//: {
      $backend_package = 'python-pysqlite2'
    }
    default: {
      fail('Unsupported backend configured')
    }
  }

  if $backend_package and !defined(Package[$backend_package]) {
    package {'ceilometer-backend-package':
      ensure => present,
      name   => $backend_package,
    }
  }

  ceilometer_config {
    'DEFAULT/database_connection': value => $database_connection;
  }

  Ceilometer_config['DEFAULT/database_connection'] ~> Exec['ceilometer-dbsync']

  exec{ 'ceilometer-dbsync':
    command     => $::ceilometer::params::dbsync_command,
    require     => Package['ceilometer-collector'],
    user        => $::ceilometer::params::username,
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => Ceilometer
  }

}
