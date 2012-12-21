class ceilometer::db::mysql(
  $password,
  $dbname        = 'ceilometer',
  $user          = 'ceilometer',
  $host          = 'localhost',
  $allowed_hosts = undef,
  $charset       = 'latin1',
) {

  Class['mysql::server'] -> Class['ceilometer::db::mysql']
  Class['ceilometer::db::mysql'] -> Exec<| title == 'ceilometer-dbsync' |>
  Mysql::Db[$dbname] ~> Exec<| title == 'ceilometer-dbsync' |>

  mysql::db { $dbname:
    user         => $user,
    password     => $password,
    host         => $host,
    charset      => $charset,
    require      => Class['mysql::config'],
  }

  if $allowed_hosts {
     ceilometer::db::mysql::host_access { $allowed_hosts:
      user      => $user,
      password  => $password,
      database  => $dbname,
    }
  }
}
