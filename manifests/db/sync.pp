#
# Class to execute ceilometer dbsync
#
class ceilometer::db::sync {

  include ::ceilometer::params

  Package<| tag == 'ceilometer-package' |> ~> Exec['ceilometer-dbsync']
  Exec['ceilometer-dbsync'] ~> Service <| tag == 'ceilometer-service' |>

  Ceilometer_config<||> -> Exec['ceilometer-dbsync']
  Ceilometer_config<| title == 'database/connection' |> ~> Exec['ceilometer-dbsync']

  exec { 'ceilometer-dbsync':
    command     => $::ceilometer::params::dbsync_command,
    path        => '/usr/bin',
    user        => $::ceilometer::params::user,
    refreshonly => true,
    logoutput   => on_failure,
  }

}
