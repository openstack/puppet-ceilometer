# == Class: ceilometer::db
#
#  Configures the ceilometer database
#  This class will install the required libraries depending on the driver
#  specified in the connection_string parameter
#
# === Parameters:
#
# [*database_connection*]
#   (Optional) Url used to connect to database.
#   Defaults to 'mysql://ceilometer:ceilometer@localhost/ceilometer'.
#
# [*database_idle_timeout*]
#   (Optional) Timeout when db connections should be reaped.
#   Defaults to $::os_service_default.
#
# [*database_min_pool_size*]
#   (Optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_pool_size*]
#   (Optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_retries*]
#   (Optional) Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   Defaults to $::os_service_default.
#
# [*database_retry_interval*]
#   (Optional) Interval between retries of opening a sql connection.
#   Defaults to $::os_service_default.
#
# [*database_max_overflow*]
#   (Optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $::os_service_default.
#
# [*mongodb_replica_set*]
#   (Optional) DEPRECATED. The name of the replica set which is used to connect to MongoDB
#   database. If it is set, MongoReplicaSetClient will be used instead
#   of MongoClient.
#   Defaults to undef (string value).
#
# [*sync_db*]
#   (Optional) enable dbsync.
#   Defaults to true.
#
class ceilometer::db (
  $database_connection     = 'mysql://ceilometer:ceilometer@localhost/ceilometer',
  $database_idle_timeout   = $::os_service_default,
  $database_min_pool_size  = $::os_service_default,
  $database_max_pool_size  = $::os_service_default,
  $database_max_retries    = $::os_service_default,
  $database_retry_interval = $::os_service_default,
  $database_max_overflow   = $::os_service_default,
  $sync_db                 = true,
  # DEPRECATED PARAMETERS
  $mongodb_replica_set     = undef,
) {

  include ::ceilometer::params

  Package<| title == 'ceilometer-common' |> -> Class['ceilometer::db']

  if $mongodb_replica_set {
    warning('mongodb_replica_set parameter is deprecated in Mitaka and has no effect. Add ?replicaSet=myreplicatset in database_connection instead.')
  }

  validate_re($database_connection,
    '^(sqlite|mysql(\+pymysql)?|postgresql|mongodb):\/\/(\S+:\S+@\S+\/\S+)?')

  case $database_connection {
    /^mysql(\+pymysql)?:\/\//: {
      require 'mysql::bindings'
      require 'mysql::bindings::python'
      if $database_connection =~ /^mysql\+pymysql/ {
        $backend_package = $::ceilometer::params::pymysql_package_name
      } else {
        $backend_package = false
      }
    }
    /^postgresql:\/\//: {
      $backend_package = false
      require 'postgresql::lib::python'
    }
    /^mongodb:\/\//: {
      $backend_package = $::ceilometer::params::pymongo_package_name
    }
    /^sqlite:\/\//: {
      $backend_package = $::ceilometer::params::sqlite_package_name
    }
    default: {
      fail('Unsupported backend configured')
    }
  }

  if $backend_package and !defined(Package[$backend_package]) {
    package {'ceilometer-backend-package':
      ensure => present,
      name   => $backend_package,
      tag    => 'openstack',
    }
  }

  ceilometer_config {
    'database/connection':     value => $database_connection, secret => true;
    'database/idle_timeout':   value => $database_idle_timeout;
    'database/min_pool_size':  value => $database_min_pool_size;
    'database/max_retries':    value => $database_max_retries;
    'database/retry_interval': value => $database_retry_interval;
    'database/max_pool_size':  value => $database_max_pool_size;
    'database/max_overflow':   value => $database_max_overflow;
  }

  if $sync_db {
    include ::ceilometer::db::sync
  }

}
