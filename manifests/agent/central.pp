# == Class: ceilometer::agent::central
#
# Installs/configures the ceilometer central agent
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
#   Defaults to 'present'.
#
# [*coordination_url*]
#   (Optional) The url to use for distributed group membership coordination.
#   Defaults to undef.
#

class ceilometer::agent::central (
  $manage_service   = true,
  $enabled          = true,
  $package_ensure   = 'present',
  $coordination_url = undef,
) {

  include ::ceilometer::deps
  include ::ceilometer::params

  warning('This class is deprecated. Please use ceilometer::agent::polling with central namespace instead.')

  package { 'ceilometer-agent-central':
    ensure => $package_ensure,
    name   => $::ceilometer::params::agent_central_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'ceilometer-agent-central':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::agent_central_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'ceilometer-service',
  }

  if $coordination_url {
    ensure_resource('ceilometer_config', 'coordination/backend_url',
      {'value' => $coordination_url})
  }
}
