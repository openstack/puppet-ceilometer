# Installs/configures the ceilometer central agent
#
# == Parameters
#  [*auth_url*]
#    Keystone URL. Optional. Defaults to 'http://localhost:5000/v2.0'
#
#  [*auth_region*]
#    Keystone region. Optional. Defaults to 'RegionOne'
#
#  [*auth_user*]
#    Keystone user for ceilometer. Optional. Defaults to 'ceilometer'
#
#  [*auth_password*]
#    Keystone password for ceilometer. Optional. Defaults to 'password'
#
#  [*auth_tenant_name*]
#    Keystone tenant name for ceilometer. Optional. Defauls to 'services'
#
#  [*auth_tenant_id*]
#    Keystone tenant id for ceilometer. Optional. Defaults to ''
#
#  [*enabled*]
#    Should the service be enabled. Optional. Defauls to true
#
class ceilometer::agent::central (
  $auth_url         = 'http://localhost:5000/v2.0',
  $auth_region      = 'RegionOne',
  $auth_user        = 'ceilometer',
  $auth_password    = 'password',
  $auth_tenant_name = 'services',
  $auth_tenant_id   = '',
  $enabled          = true,
) {

  include ceilometer::params

  Ceilometer_config<||> ~> Service['ceilometer-agent-central']

  Package['ceilometer-agent-central'] -> Service['ceilometer-agent-central']
  package { 'ceilometer-agent-central':
    ensure => installed,
    name   => $::ceilometer::params::agent_central_package_name,
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  Package['ceilometer-common'] -> Service['ceilometer-agent-central']
  service { 'ceilometer-agent-central':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::agent_central_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }

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
