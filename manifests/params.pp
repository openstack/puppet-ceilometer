# == Class: ceilometer::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
#
class ceilometer::params {
  include ::openstacklib::defaults

  $dbsync_command  = 'ceilometer-upgrade'
  $expirer_command = 'ceilometer-expirer'
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
    'disk.read.bytes',
    'disk.read.requests',
    'disk.write.bytes',
    'disk.write.requests',
    'volume.size',
    'volume.snapshot.size',
    'volume.backup.size',
    'hardware.cpu.util',
    'hardware.memory.used',
    'hardware.memory.total',
    'hardware.memory.buffer',
    'hardware.memory.cached',
    'hardware.memory.swap.avail',
    'hardware.memory.swap.total',
    'hardware.system_stats.io.outgoing.blocks',
    'hardware.system_stats.io.incoming.blocks',
    'hardware.network.ip.incoming.datagrams',
    'hardware.network.ip.outgoing.datagrams',
  ]

  case $::osfamily {
    'RedHat': {
      # package names
      $agent_central_package_name      = 'openstack-ceilometer-central'
      $agent_compute_package_name      = 'openstack-ceilometer-compute'
      $agent_polling_package_name      = 'openstack-ceilometer-polling'
      $agent_notification_package_name = 'openstack-ceilometer-notification'
      $common_package_name             = 'openstack-ceilometer-common'
      # service names
      $agent_central_service_name      = 'openstack-ceilometer-central'
      $agent_compute_service_name      = 'openstack-ceilometer-compute'
      $agent_polling_service_name      = 'openstack-ceilometer-polling'
      $agent_notification_service_name = 'openstack-ceilometer-notification'
      $ceilometer_wsgi_script_path     = '/var/www/cgi-bin/ceilometer'
      $ceilometer_wsgi_script_source   = '/usr/lib/python2.7/site-packages/ceilometer/api/app.wsgi'
      $libvirt_group                   = undef
    }
    'Debian': {
      # package names
      $agent_central_package_name      = 'ceilometer-agent-central'
      $agent_compute_package_name      = 'ceilometer-agent-compute'
      $agent_polling_package_name      = 'ceilometer-polling'
      $agent_notification_package_name = 'ceilometer-agent-notification'
      $common_package_name             = 'ceilometer-common'
      # service names
      $agent_central_service_name      = 'ceilometer-agent-central'
      $agent_compute_service_name      = 'ceilometer-agent-compute'
      $agent_polling_service_name      = 'ceilometer-polling'
      $agent_notification_service_name = 'ceilometer-agent-notification'
      $libvirt_group                   = 'libvirt'
      $ceilometer_wsgi_script_path    = '/usr/lib/cgi-bin/ceilometer'
      $ceilometer_wsgi_script_source  = '/usr/lib/python2.7/dist-packages/ceilometer/api/app.wsgi'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: \
${::operatingsystem}, module ${module_name} only support osfamily \
RedHat and Debian")
    }
  }
}
