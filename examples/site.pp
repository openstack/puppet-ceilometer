node default {
  # Add the base ceilometer class & parameters
  # This class is required by ceilometer agents & api classes
  # The telemetry_secret parameter is mandatory
  class { 'ceilometer':
    telemetry_secret => 'darksecret',
  }

  class { 'ceilometer::db::sync': }

  class { 'ceilometer::keystone::auth':
    password => 'a_big_secret',
  }

  # Set common auth parameters used by all agents (compute/central)
  class { 'ceilometer::agent::service_credentials':
    auth_url => 'http://localhost:5000/v3',
    password => 'a_big_secret',
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
  class { 'ceilometer::agent::notification': }
}
