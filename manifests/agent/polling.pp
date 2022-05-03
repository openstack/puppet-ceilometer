# == Class: ceilometer::agent::polling
#
# Installs/configures the ceilometer polling agent
#
# === Parameters:
#
# [*enabled*]
#   (Optional) Should the service be enabled.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional)  Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'
#
# [*central_namespace*]
#   (Optional) Use central namespace for polling agent.
#   Defaults to true.
#
# [*compute_namespace*]
#   (Optional) Use compute namespace for polling agent.
#   Defaults to true.
#
# [*ipmi_namespace*]
#   (Optional) Use ipmi namespace for polling agent.
#   Defaults to true.
#
# [*coordination_url*]
#   (Optional) The url to use for distributed group membership coordination.
#   Defaults to $::os_service_default.
#
# [*instance_discovery_method*]
#   (Optional) method to discovery instances running on compute node
#   Defaults to $::os_service_default
#    * naive: poll nova to get all instances
#    * workload_partitioning: poll nova to get instances of the compute
#    * libvirt_metadata: get instances from libvirt metadata
#      but without instance metadata (recommended for Gnocchi backend).
#
# [*resource_update_interval*]
#   (Optional) New instances will be discovered periodically based on this
#   option (in seconds).
#   Defaults to $::os_service_default.
#
# [*resource_cache_expiry*]
#   (Optional) The expiry to totally refresh the instances resource cache.
#   Defaults to $::os_service_default.
#
# [*manage_polling*]
#   (Optional) Whether to manage polling.yaml
#   Defaults to false
#
# [*polling_interval*]
#   (Optional) Number of seconds between polling cycle
#   Defaults to 600 seconds, used only if manage_polling is true.
#
# [*polling_meters*]
#   (Optional) Array of strings with meters to add to
#   the polling.yaml file, used only if manage_polling is true.
#   Defaults to $::ceilometer::params::polling_meters
#
# [*polling_config*]
#   (Optional) A hash of the polling.yaml configuration.
#   This is used only if manage_polling is true.
#   Defaults to undef
#
# [*batch_size*]
#   (Optional) Batch size of samples to send to notification agent.
#   Defaults to $::os_service_default
#
class ceilometer::agent::polling (
  $manage_service            = true,
  $enabled                   = true,
  $package_ensure            = 'present',
  $central_namespace         = true,
  $compute_namespace         = true,
  $ipmi_namespace            = true,
  $coordination_url          = $::os_service_default,
  $instance_discovery_method = $::os_service_default,
  $resource_update_interval  = $::os_service_default,
  $resource_cache_expiry     = $::os_service_default,
  $manage_polling            = false,
  $polling_interval          = 600,
  $polling_meters            = $::ceilometer::params::polling_meters,
  $polling_config            = undef,
  $batch_size                = $::os_service_default,
) inherits ceilometer {

  include ceilometer::deps
  include ceilometer::params

  if $central_namespace {
    $central_namespace_name = 'central'
  } else {
    $central_namespace_name = undef
  }

  if $compute_namespace {
    if $::ceilometer::params::libvirt_group {
      User['ceilometer'] {
        groups => ['nova', $::ceilometer::params::libvirt_group]
      }
      Package <| title == 'libvirt' |> -> User['ceilometer']
    } else {
      User['ceilometer'] {
        groups => ['nova']
      }
    }

    $compute_namespace_name = 'compute'

    Package <| title == 'ceilometer-common' |> -> User['ceilometer']
    Package <| title == 'nova-common' |> -> Package['ceilometer-common']

    ceilometer_config {
      'compute/instance_discovery_method': value => $instance_discovery_method;
      'compute/resource_update_interval':  value => $resource_update_interval;
      'compute/resource_cache_expiry':     value => $resource_cache_expiry;
    }
  } else {
    $compute_namespace_name = undef
    ceilometer_config {
      'compute/instance_discovery_method': ensure => absent;
      'compute/resource_update_interval':  ensure => absent;
      'compute/resource_cache_expiry':     ensure => absent;
    }
  }

  if $ipmi_namespace {
    $ipmi_namespace_name = 'ipmi'
  } else {
    $ipmi_namespace_name = undef
  }

  package { 'ceilometer-polling':
    ensure => $package_ensure,
    name   => $::ceilometer::params::agent_polling_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  $namespaces_real = delete_undef_values([
    $central_namespace_name,
    $compute_namespace_name,
    $ipmi_namespace_name
  ])

  if empty($namespaces_real) {
    ceilometer_config {
      'DEFAULT/polling_namespaces': ensure => absent
    }
  } else {
    ceilometer_config {
      'DEFAULT/polling_namespaces': value => join($namespaces_real, ',')
    }
  }

  ceilometer_config {
    'polling/batch_size': value => $batch_size
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'ceilometer-polling':
      ensure     => $service_ensure,
      name       => $::ceilometer::params::agent_polling_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'ceilometer-service',
    }
  }

  if $coordination_url == undef {
    warning('Usage of undef for the coordination_url parameter has been deprecated. \
Use $::os_service_default instead')
    $coordination_url_real = $::os_service_default
  } else {
    $coordination_url_real = $coordination_url
  }
  ceilometer_config {
    'coordination/backend_url': value => $coordination_url_real
  }

  if $manage_polling {
    if $polling_config {
      validate_legacy(Hash, 'validate_hash', $polling_config)
      $polling_content = to_yaml($polling_config)
    } else {
      $polling_content = template('ceilometer/polling.yaml.erb')
    }

    file { 'polling':
      ensure                  => present,
      path                    => $::ceilometer::params::polling,
      content                 => $polling_content,
      selinux_ignore_defaults => true,
      tag                     => 'ceilometer-yamls',
    }
  }
}
