# Ceilometer::Agent::Central
#
#
class ceilometer::agent::central(
  $auth_url         = 'http://localhost:5000/v2.0',
  $auth_region      = 'RegionOne',
  $auth_user        = 'ceilometer',
  $auth_password    = 'password',
  $auth_tenant_name = 'services',
  $auth_tenant_id   = '',
  $enabled          = true,
) inherits ceilometer {

  package { 'ceilometer-agent-central':
    ensure => installed
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-agent-central':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::agent_central_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['ceilometer-agent-central']
  }

  Ceilometer_config<||> ~> Service['ceilometer-agent-central']

  ceilometer_config {
    'DEFAULT/os_auth_url'         : value => $auth_url;
    'DEFAULT/os_auth_region'      : value => $auth_region;
    'DEFAULT/os_username'         : value => $auth_user;
    'DEFAULT/os_password'         : value => $auth_password;
    'DEFAULT/os_tenant_name'      : value => $auth_tenant_name;
  }

  if ($auth_tenant_id != '') {
    ceilometer_config {
      'DEFAULT/os_tenant_id'        : value => $auth_tenant_id;
    }
  }
}
