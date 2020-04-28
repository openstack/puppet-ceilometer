node default {
  Exec {
    path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin']
  }

  # First, install a mysql server
  class { 'mysql::server': }
  # And create the database
  class { 'ceilometer::db::mysql':
    password => 'ceilometer',
  }

  # Add the base ceilometer class & parameters
  # This class is required by ceilometer agents & api classes
  # The telemetry_secret parameter is mandatory
  class { 'ceilometer':
    telemetry_secret => 'darksecret'
  }

  # Configure the ceilometer database
  # Only needed if ceilometer::agent::polling or ceilometer::api are declared
  class { 'ceilometer::db':
  }

  # Configure ceilometer database with mongodb

  # class { 'ceilometer::db':
  #   database_connection => 'mongodb://localhost:27017/ceilometer',
  #   require             => Class['mongodb'],
  # }

  # Set common auth parameters used by all agents (compute/central)
  class { 'ceilometer::agent::auth':
    auth_url      => 'http://localhost:5000/v3',
    auth_password => 'tralalerotralala'
  }

  # Install polling agent
  # Can be used instead of central, compute or ipmi agent
  # class { 'ceilometer::agent::polling':
  #   central_namespace => true,
  #   compute_namespace => false,
  #   ipmi_namespace    => false
  # }
  # class { 'ceilometer::agent::polling':
  #   central_namespace => false,
  #   compute_namespace => true,
  #   ipmi_namespace    => false
  # }
  # class { 'ceilometer::agent::polling':
  #   central_namespace => false,
  #   compute_namespace => false,
  #   ipmi_namespace    => true
  # }
  # As default use central and compute polling namespaces
  class { 'ceilometer::agent::polling':
    central_namespace => true,
    compute_namespace => true,
    ipmi_namespace    => false,
  }

  # Install notification agent
  class { 'ceilometer::agent::notification':
  }

}
