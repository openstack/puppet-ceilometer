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
#   Defaults to undef.
#
# [*instance_discovery_method*]
#   (Optional) method to discovery instances running on compute node
#   Defaults to $::os_service_default
#    * naive: poll nova to get all instances
#    * workload_partitioning: poll nova to get instances of the compute
#    * libvirt_metadata: get instances from libvirt metadata
#      but without instance metadata (recommended for Gnocchi backend).
#
# [*manage_polling*]
#   (Optional) Whether to manage polling.yaml
#   Defaults to false
#
# [*polling_interval*]
#   (Optional) Number of seconds between polling cycle
#   Defaults to 600 seconds, used only if manage_polling is true.
#
class ceilometer::agent::polling (
  $manage_service            = true,
  $enabled                   = true,
  $package_ensure            = 'present',
  $central_namespace         = true,
  $compute_namespace         = true,
  $ipmi_namespace            = true,
  $coordination_url          = undef,
  $instance_discovery_method = $::os_service_default,
  $manage_polling            = false,
  $polling_interval          = 600,
) inherits ceilometer {

  include ::ceilometer::deps
  include ::ceilometer::params

  if $central_namespace {
    $central_namespace_name = 'central'
  } else {
    $central_namespace_name = ''
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
      'compute/instance_discovery_method': value => $instance_discovery_method,
    }
  } else {
    $compute_namespace_name = ''
  }

  if $ipmi_namespace {
    $ipmi_namespace_name = 'ipmi'
  } else {
    $ipmi_namespace_name = ''
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  $namespaces = delete([$central_namespace_name, $compute_namespace_name, $ipmi_namespace_name], '')
  $namespaces_real = inline_template('<%= @namespaces.select { |x| x and x !~ /^undef/ }.compact.join "," %>')

  package { 'ceilometer-polling':
    ensure => $package_ensure,
    name   => $::ceilometer::params::agent_polling_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  if $namespaces_real {
    ceilometer_config {
      'DEFAULT/polling_namespaces': value => $namespaces_real
    }
  }

  service { 'ceilometer-polling':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::agent_polling_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'ceilometer-service',
  }

  if $coordination_url {
    ceilometer_config {
      'coordination/backend_url': value => $coordination_url
    }
  }

  if $manage_polling {
    file { 'polling':
      ensure                  => present,
      path                    => $::ceilometer::params::polling,
      content                 => template('ceilometer/polling.yaml.erb'),
      selinux_ignore_defaults => true,
      tag                     => 'ceilometer-yamls',
    }
  }
}
