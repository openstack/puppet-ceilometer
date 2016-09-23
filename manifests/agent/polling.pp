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
class ceilometer::agent::polling (
  $manage_service    = true,
  $enabled           = true,
  $package_ensure    = 'present',
  $central_namespace = true,
  $compute_namespace = true,
  $ipmi_namespace    = true,
  $coordination_url  = undef,
) inherits ceilometer {

  include ::ceilometer::params

  if $central_namespace {
    $central_namespace_name = 'central'
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
  }

  if $ipmi_namespace {
    $ipmi_namespace_name = 'ipmi'
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

  Ceilometer_config<||> ~> Service['ceilometer-polling']
  Package['ceilometer-polling'] -> Service['ceilometer-polling']
  Package['ceilometer-common'] -> Service['ceilometer-polling']

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
}
