# == Class: ceilometer::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
#
class ceilometer::params {

  assert_private()

  include openstacklib::defaults

  $dbsync_command  = 'ceilometer-upgrade'
  $user            = 'ceilometer'
  $event_pipeline  = '/etc/ceilometer/event_pipeline.yaml'
  $pipeline        = '/etc/ceilometer/pipeline.yaml'
  $polling         = '/etc/ceilometer/polling.yaml'
  $group           = 'ceilometer'
  $polling_meters  = [
    'cpu',
    'cpu_l3_cache',
    'memory.usage',
    'network.incoming.bytes',
    'network.incoming.packets',
    'network.outgoing.bytes',
    'network.outgoing.packets',
    'disk.device.read.bytes',
    'disk.device.read.requests',
    'disk.device.write.bytes',
    'disk.device.write.requests',
    'volume.size',
    'volume.snapshot.size',
    'volume.backup.size',
  ]

  case $::osfamily {
    'RedHat': {
      # package names
      $agent_polling_package_name      = 'openstack-ceilometer-polling'
      $agent_central_package_name      = 'openstack-ceilometer-central'
      $agent_compute_package_name      = 'openstack-ceilometer-compute'
      $agent_ipmi_package_name         = 'openstack-ceilometer-ipmi'
      $agent_notification_package_name = 'openstack-ceilometer-notification'
      $common_package_name             = 'openstack-ceilometer-common'
      # service names
      $agent_polling_service_name      = 'openstack-ceilometer-polling'
      $agent_central_service_name      = 'openstack-ceilometer-central'
      $agent_compute_service_name      = 'openstack-ceilometer-compute'
      $agent_ipmi_service_name         = 'openstack-ceilometer-ipmi'
      $agent_notification_service_name = 'openstack-ceilometer-notification'
      $libvirt_group                   = undef
    }
    'Debian': {
      # package names
      $agent_polling_package_name      = 'ceilometer-polling'
      $agent_central_package_name      = 'ceilometer-agent-central'
      $agent_compute_package_name      = 'ceilometer-agent-compute'
      $agent_ipmi_package_name         = 'ceilometer-agent-ipmi'
      $agent_notification_package_name = 'ceilometer-agent-notification'
      $common_package_name             = 'ceilometer-common'
      # service names
      $agent_polling_service_name      = 'ceilometer-polling'
      $agent_central_service_name      = 'ceilometer-agent-central'
      $agent_compute_service_name      = 'ceilometer-agent-compute'
      $agent_ipmi_service_name         = 'ceilometer-agent-ipmi'
      $agent_notification_service_name = 'ceilometer-agent-notification'
      $libvirt_group                   = 'libvirt'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: \
${::operatingsystem}, module ${module_name} only support osfamily \
RedHat and Debian")
    }
  }
}
