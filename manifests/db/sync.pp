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
# [*skip_gnocchi_resource_types*]
#   (Optional) Skip gnocchi resource-types upgrade.
#   Defaults to false
#
class ceilometer::db::sync (
  $extra_params                        = undef,
  $db_sync_timeout                     = 300,
  Boolean $skip_gnocchi_resource_types = false,
) {
  include ceilometer::deps
  include ceilometer::params

  $skip_opt = $skip_gnocchi_resource_types ? {
    true    => '--skip-gnocchi-resource-types ',
    default => ''
  }

  exec { 'ceilometer-upgrade':
    command     => "${ceilometer::params::dbsync_command} ${skip_opt}${extra_params}",
    path        => '/usr/bin',
    user        => $ceilometer::params::user,
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
