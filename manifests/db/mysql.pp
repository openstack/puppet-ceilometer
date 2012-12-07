#
# I should change this to mysql
# for consistency
#
class ceilometer::db::mysql(
  $password,
  $dbname        = 'ceilometer',
  $user          = 'ceilometer',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'latin1',
  $cluster_id    = 'localzone'
) {

  Class['mysql::server']     -> Class['ceilometer::db::mysql']
  Class['glance::db::mysql'] -> Exec<| title == 'ceilometer-dbsync' |>
  Database[$dbname]          ~> Exec<| title == 'ceilometer-dbsync' |>

  require 'mysql::python'

  mysql::db { $dbname:
    user         => $user,
    password     => $password,
    host         => $host,
    charset      => $charset,
    # I may want to inject some sql
    require      => Class['mysql::config'],
  }

  if $allowed_hosts {
     # TODO this class should be in the mysql namespace
     glance::db::mysql::host_access { $allowed_hosts:
      user      => $user,
      password  => $password,
      database  => $dbname,
    }
  }
}
