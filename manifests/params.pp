#
class ceilometer::params {

  $username       = 'ceilometer'
  $groupname      = 'ceilometer'
  $cinder_conf    = '/etc/ceilometer/ceilometer.conf'
  $dbsync_command = "ceilometer-dbsync --config-file=${cinder_conf}"
  $log_dir        = '/var/log/ceilometer'

  case $::osfamily {
    'RedHat': {
      # package names
      $agent_central_package_name = 'openstack-ceilometer-central'
      $agent_compute_package_name = 'openstack-ceilometer-compute'
      $api_package_name           = 'openstack-ceilometer-api'
      $collector_package_name     = 'openstack-ceilometer-collector'
      $common_package_name        = 'openstack-ceilometer-common'
      $client_package_name        = 'python-ceilometerclient'
      # service names
      $agent_central_service_name = 'openstack-ceilometer-central'
      $agent_compute_service_name = 'openstack-ceilometer-compute'
      $api_service_name           = 'openstack-ceilometer-api'
      $collector_service_name     = 'openstack-ceilometer-collector'

    }
    'Debian': {
      # package names
      $agent_central_package_name = 'ceilometer-agent-central'
      $agent_compute_package_name = 'ceilometer-agent-compute'
      $api_package_name           = 'ceilometer-api'
      $collector_package_name     = 'ceilometer-collector'
      $common_package_name        = 'ceilometer-common'
      $client_package_name        = 'python-ceilometer'
      # service names
      $agent_central_service_name = 'ceilometer-agent-central'
      $agent_compute_service_name = 'ceilometer-agent-compute'
      $api_service_name           = 'ceilometer-api'
      $collector_service_name     = 'ceilometer-collector'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }
}
