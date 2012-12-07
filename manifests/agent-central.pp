class ceilometer::agent-central(
  $enabled = true,
) {

  package { 'ceilometer-agent-central':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-agent-central':
    name	=> $::ceilometer::params::agent_central_name
    enable      => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require => Package['ceilometer-agent-central']
  }

}
