# == Class: ceilometer::db::sync
#
# Class to execute ceilometer database schema creation
#
# === Parameters:
#
# [*extra_params*]
#   (Optional) String of extra command line parameters
#   to append to the ceilometer-upgrade command.
#   Defaults to undef.
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class ceilometer::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include ceilometer::deps
  include ceilometer::params

  exec { 'ceilometer-upgrade':
    command     => "${::ceilometer::params::dbsync_command} ${extra_params}",
    path        => '/usr/bin',
    user        => $::ceilometer::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['ceilometer::install::end'],
      Anchor['ceilometer::config::end'],
      Anchor['ceilometer::dbsync::begin']
    ],
    notify      => Anchor['ceilometer::dbsync::end'],
    tag         => 'openstack-db',
  }

}
