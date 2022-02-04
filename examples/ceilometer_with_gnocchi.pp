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
class { 'ceilometer::agent::polling': }
class { 'ceilometer::agent::notification':
  manage_pipeline           => true,
  pipeline_publishers       => ['gnocchi://'],
  manage_event_pipeline     => true,
  event_pipeline_publishers => ['gnocchi://'],
}
class { 'ceilometer::agent::service_credentials':
  password => 'a_big_secret',
}

class { 'ceilometer::collector':
  meter_dispatchers => ['gnocchi'],
}
