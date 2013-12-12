# Parameters for puppet-ceilometer
#
class ceilometer::params {

  $dbsync_command  = 'ceilometer-dbsync --config-file=/etc/ceilometer/ceilometer.conf'
  $log_dir         = '/var/log/ceilometer'
  $expirer_command = 'ceilometer-expirer'

  case $::osfamily {
    'RedHat': {
      # package names
      $agent_central_package_name   = 'openstack-ceilometer-central'
      $agent_compute_package_name   = 'openstack-ceilometer-compute'
      $api_package_name             = 'openstack-ceilometer-api'
      $collector_package_name       = 'openstack-ceilometer-collector'
      $alarm_package_name           = 'openstack-ceilometer-alarm'
      $common_package_name          = 'openstack-ceilometer-common'
      $client_package_name          = 'python-ceilometerclient'
      # service names
      $agent_central_service_name   = 'openstack-ceilometer-central'
      $agent_compute_service_name   = 'openstack-ceilometer-compute'
      $api_service_name             = 'openstack-ceilometer-api'
      $collector_service_name       = 'openstack-ceilometer-collector'
      $alarm_notifier_service_name  = 'openstack-ceilometer-alarm-notifier'
      $alarm_evaluator_service_name = 'openstack-ceilometer-alarm-evaluator'
      $pymongo_package_name         = 'python-pymongo'
      $psycopg_package_name         = 'python-psycopg2'
      # db packages
      if $::operatingsystem == 'Fedora' and $::operatingsystemrelease >= 18 {
        # fallback to stdlib version, not provided on fedora
        $sqlite_package_name      = undef
      } else {
        $sqlite_package_name      = 'python-sqlite2'
      }

    }
    'Debian': {
      # package names
      $agent_central_package_name           = 'ceilometer-agent-central'
      $agent_compute_package_name           = 'ceilometer-agent-compute'
      $api_package_name                     = 'ceilometer-api'
      $collector_package_name               = 'ceilometer-collector'
      $common_package_name                  = 'ceilometer-common'
      $client_package_name                  = 'python-ceilometerclient'
      $alarm_package_name                   = ['ceilometer-alarm-evaluator', 'ceilometer-alarm-notifier' ]
      # service names
      $agent_central_service_name   = 'ceilometer-agent-central'
      $agent_compute_service_name   = 'ceilometer-agent-compute'
      $api_service_name             = 'ceilometer-api'
      $collector_service_name       = 'ceilometer-collector'
      $alarm_notifier_service_name  = 'ceilometer-alarm-notifier'
      $alarm_evaluator_service_name = 'ceilometer-alarm-evaluator'
      # db packages
      $psycopg_package_name       = 'python-psycopg2'
      $pymongo_package_name       = 'python-pymongo'
      $sqlite_package_name        = 'python-pysqlite2'

      # Operating system specific
      case $::operatingsystem {
        'Ubuntu': {
          $libvirt_group = 'libvirtd'
        }
        default: {
          $libvirt_group = 'libvirt'
        }
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: \
${::operatingsystem}, module ${module_name} only support osfamily \
RedHat and Debian")
    }
  }
}
