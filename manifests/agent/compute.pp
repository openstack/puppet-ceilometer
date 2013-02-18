# Ceilometer::Agent::Compute
#
#
class ceilometer::agent::compute(
  $auth_url         = 'http://localhost:5000/v2.0',
  $auth_region      = 'RegionOne',
  $auth_user        = 'ceilometer',
  $auth_password    = 'password',
  $auth_tenant_name = 'services',
  $auth_tenant_id   = '',
  $enabled          = true,
) inherits ceilometer {

  package { 'ceilometer-agent-compute':
    ensure => installed
  }

  User['ceilometer'] {
    groups +> ['libvirt']
  }

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'ceilometer-agent-compute':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::agent_compute_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['ceilometer-agent-compute']
  }

  Ceilometer_config<||> ~> Service['ceilometer-agent-compute']

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

  nova_config {
    'instance_usage_audit'        : value => 'True';
    'instance_usage_audit_period' : value => 'hour';
  }

  Nova_config<| |> {
    before +> Exec[
      'nova-notification-driver-common',
      'nova-notification-driver-ceilometer'
    ],
  }

  exec { 'nova-notification-driver-common':
    command => 'git config --file nova.conf --add notification_driver nova.openstack.common.notifier.rabbit_notifier',
    onlyif  => 'git config --file nova.conf --get notification_driver nova.openstack.common.notifier.rabbit_notifier',
  }

  exec { 'nova-notification-driver-ceilometer':
    command => 'git config --file nova.conf --add notification_driver ceilometer.compute.nova_notifier',
    onlyif  => 'git config --file nova.conf --get notification_driver ceilometer.compute.nova_notifier',
  }

}
