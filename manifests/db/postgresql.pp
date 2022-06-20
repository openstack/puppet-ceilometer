# == Class: ceilometer::db::postgresql
#
# Class that configures postgresql for ceilometer
# Requires the Puppetlabs postgresql module.
#
# === Parameters:
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'ceilometer'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'ceilometer'.
#
# [*encoding*]
#   (Optional) The charset to use for the database.
#   Default to undef.
#
# [*privileges*]
#   (Optional) Privileges given to the database user.
#   Default to 'ALL'.
#
class ceilometer::db::postgresql(
  $password,
  $dbname     = 'ceilometer',
  $user       = 'ceilometer',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ceilometer::deps

  warning('The ceilometer::db::postgresql class has been deprecated and will be removed in a future release.')

  openstacklib::db::postgresql { 'ceilometer':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['ceilometer::db::begin']
  ~> Class['ceilometer::db::postgresql']
  ~> Anchor['ceilometer::db::end']
}
