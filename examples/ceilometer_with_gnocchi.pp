class { 'ceilometer':
  telemetry_secret      => 'secrete',
  default_transport_url => 'rabbit://ceilometer:an_even_bigger_secret@127.0.0.1:5672',
}
class { 'ceilometer::db::mysql':
  password => 'a_big_secret',
}
class { 'ceilometer::db':
  database_connection => 'mysql://ceilometer:a_big_secret@127.0.0.1/ceilometer?charset=utf8',
}
class { 'ceilometer::keystone::auth':
  password => 'a_big_secret',
}
class { 'ceilometer::expirer': }
class { 'ceilometer::agent::polling': }
class { 'ceilometer::agent::notification': }

class { 'ceilometer::collector':
  meter_dispatchers => ['gnocchi'],
}
class { 'ceilometer::dispatcher::gnocchi':
  filter_service_activity   => false,
  filter_project            => 'gnocchi_swift',
  url                       => 'https://gnocchi:8041',
  archive_policy            => 'high',
  resources_definition_file => 'gnocchi.yaml',
}
