# Ceilometer::Agent::Compute
#
#
class ceilometer::agent::compute(
  $enabled = true,
) {

  package { 'ceilometer-agent-compute':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-agent-compute':
    name       => $::ceilometer::params::agent_compute_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['ceilometer-agent-compute']
  }

}
