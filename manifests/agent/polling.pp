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
# [*separate_services*]
#   (Optional) Use separate services for individual namespace.
#   Defaults to false.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'
#
# [*manage_user*]
#   (Optional) Should the system user should be managed. When this flag is
#   true then the class ensures the ceilometer user belongs to nova/libvirt
#   group.
#   Defaults to true.
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
# [*instance_discovery_method*]
#   (Optional) method to discovery instances running on compute node
#   Defaults to $facts['os_service_default']
#    * naive: poll nova to get all instances
#    * workload_partitioning: poll nova to get instances of the compute
#    * libvirt_metadata: get instances from libvirt metadata
#      but without instance metadata (recommended for Gnocchi backend).
#
# [*resource_update_interval*]
#   (Optional) New instances will be discovered periodically based on this
#   option (in seconds).
#   Defaults to $facts['os_service_default'].
#
# [*resource_cache_expiry*]
#   (Optional) The expiry to totally refresh the instances resource cache.
#   Defaults to $facts['os_service_default'].
#
# [*manage_polling*]
#   (Optional) Whether to manage polling.yaml
#   Defaults to false
#
# [*polling_interval*]
#   (Optional) Number of seconds between polling cycle
#   Defaults to 300 seconds, used only if manage_polling is true.
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
# [*cfg_file*]
#   (Optional) Configuration file for polling definition.
#   This parameter has no effect when manage_polling is true.
#   Defaults to $facts['os_service_default'].
#
# [*batch_size*]
#   (Optional) Batch size of samples to send to notification agent.
#   Defaults to $facts['os_service_default'].
#
# [*identity_name_discovery*]
#   (Optional) Identify user and project names from polled metrics.
#   Defaults to $facts['os_service_default'].
#
# [*ignore_disabled_projects*]
#   (Optional) Whether the pooling service should ignore disabled projects or
#   not.
#   Defaults to $facts['os_service_default'].
#
# [*enable_notifications*]
#   (Optional) Whether the polling service should be sending notifications.
#   Defaults to $facts['os_service_default'].
#
# [*enable_prometheus_exporter*]
#   (Optional) Alllow this polling instance to expose directly the retrieved
#   metrics in Prometheus format.
#   Defaults to $facts['os_service_default'].
#
# [*prometheus_listen_addresses*]
#   (Optional) A list of ipaddr:port combintations on which the exported
#   metrics will be exposed.
#   Defaults to $facts['os_service_default'].
#
# [*prometheus_tls_enable*]
#   (Optional) Whether it will expose tls metrics or not.
#   Defaults to $facts['os_service_default'].
#
# [*prometheus_tls_certfile*]
#   (Optional) The certificate file to allow this ceilometer to expose tls
#   scrape endpoints.
#   Defaults to $facts['os_service_default'].
#
# [*prometheus_tls_keyfile*]
#   (Optional) The private key to allow this ceilometer to expose tls scrape
#   endpoints.
#   Defaults to $facts['os_service_default'].
#
# [*pollsters_definitions_dirs*]
#   (Optional) List of directories with YAML files used to create pollsters.
#   Defaults to $facts['os_service_default'].
#
# DEPRECATED PARAMETERS
#
# [*tenant_name_discovery*]
#   (Optional) Identify user and project names from polled metrics.
#   Defaults to undef
#
class ceilometer::agent::polling (
  Boolean $manage_service          = true,
  Boolean $enabled                 = true,
  Boolean $separate_services       = false,
  $package_ensure                  = 'present',
  Boolean $manage_user             = true,
  Boolean $central_namespace       = true,
  Boolean $compute_namespace       = true,
  Boolean $ipmi_namespace          = true,
  $instance_discovery_method       = $facts['os_service_default'],
  $resource_update_interval        = $facts['os_service_default'],
  $resource_cache_expiry           = $facts['os_service_default'],
  Boolean $manage_polling          = false,
  $polling_interval                = 300,
  Array[String[1]] $polling_meters = $::ceilometer::params::polling_meters,
  Optional[Hash] $polling_config   = undef,
  $cfg_file                        = $facts['os_service_default'],
  $batch_size                      = $facts['os_service_default'],
  $identity_name_discovery         = $facts['os_service_default'],
  $ignore_disabled_projects        = $facts['os_service_default'],
  $enable_notifications            = $facts['os_service_default'],
  $enable_prometheus_exporter      = $facts['os_service_default'],
  $prometheus_listen_addresses     = $facts['os_service_default'],
  $prometheus_tls_enable           = $facts['os_service_default'],
  $prometheus_tls_certfile         = $facts['os_service_default'],
  $prometheus_tls_keyfile          = $facts['os_service_default'],
  $pollsters_definitions_dirs      = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $tenant_name_discovery           = undef,
) inherits ceilometer {

  include ceilometer::deps
  include ceilometer::params

  if $tenant_name_discovery != undef {
    warning("The tenant_name_discovery parameter is deprecated. \
Use the identity_name_discovery parameter instead.")
    $identity_name_discovery_real = $tenant_name_discovery
  } else {
    $identity_name_discovery_real = $identity_name_discovery
  }

  if $central_namespace {
    $central_namespace_name = 'central'
  } else {
    $central_namespace_name = undef
  }

  if $compute_namespace {
    if $manage_user {
      # The ceilometer user created by the ceilometer-common package does not
      # belong to nova/libvirt group. That group membership is required so that
      # the ceilometer user can access libvirt to gather some metrics.
      $ceilometer_groups = delete_undef_values([
        'nova',
        $::ceilometer::params::libvirt_group
      ])

      user { 'ceilometer':
        ensure  => present,
        name    => 'ceilometer',
        gid     => 'ceilometer',
        groups  => $ceilometer_groups,
        require => Anchor['ceilometer::install::end'],
        before  => Anchor['ceilometer::service::begin'],
      }

      if $::ceilometer::params::libvirt_group {
        Package <| title == 'libvirt' |> -> User['ceilometer']
      }
      Package <| title == 'nova-common' |> -> User['ceilometer']

      User['ceilometer'] -> Anchor['ceilometer::service::begin']
    }

    $compute_namespace_name = 'compute'
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

  if $separate_services {
    if $central_namespace {
      package { 'ceilometer-central':
        ensure => $package_ensure,
        name   =>  $::ceilometer::params::agent_central_package_name,
        tag    => ['openstack', 'ceilometer-package'],
      }
    }

    if $compute_namespace {
      package { 'ceilometer-compute':
        ensure => $package_ensure,
        name   =>  $::ceilometer::params::agent_compute_package_name,
        tag    => ['openstack', 'ceilometer-package'],
      }
    }

    if $ipmi_namespace {
      package { 'ceilometer-ipmi':
        ensure => $package_ensure,
        name   =>  $::ceilometer::params::agent_ipmi_package_name,
        tag    => ['openstack', 'ceilometer-package'],
      }
    }

  } else {
    package { 'ceilometer-polling':
      ensure => $package_ensure,
      name   => $::ceilometer::params::agent_polling_package_name,
      tag    => ['openstack', 'ceilometer-package'],
    }
  }

  $namespaces_real = delete_undef_values([
    $central_namespace_name,
    $compute_namespace_name,
    $ipmi_namespace_name
  ])

  if empty($namespaces_real) or $separate_services {
    ceilometer_config {
      'DEFAULT/polling_namespaces': ensure => absent
    }
  } else {
    ceilometer_config {
      'DEFAULT/polling_namespaces': value => join($namespaces_real, ',')
    }
  }

  ceilometer_config {
    'polling/batch_size':                  value => $batch_size;
    'polling/identity_name_discovery':     value => $identity_name_discovery_real;
    'polling/ignore_disabled_projects':    value => $ignore_disabled_projects;
    'polling/pollsters_definitions_dirs':  value => join(any2array($pollsters_definitions_dirs), ',');
    'polling/enable_notifications':        value => $enable_notifications;
    'polling/enable_prometheus_exporter':  value => $enable_prometheus_exporter;
    'polling/prometheus_listen_addresses': value => join(any2array($prometheus_listen_addresses), ',');
    'polling/prometheus_tls_enable':       value => $prometheus_tls_enable;
    'polling/prometheus_tls_certfile':     value => $prometheus_tls_certfile;
    'polling/prometheus_tls_keyfile':      value => $prometheus_tls_keyfile;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    if $separate_services {
      if $central_namespace {
        service { 'ceilometer-central':
          ensure     => $service_ensure,
          name       => $::ceilometer::params::agent_central_service_name,
          enable     => $enabled,
          hasstatus  => true,
          hasrestart => true,
          tag        => 'ceilometer-service',
        }
      }
      if $compute_namespace {
        service { 'ceilometer-compute':
          ensure     => $service_ensure,
          name       => $::ceilometer::params::agent_compute_service_name,
          enable     => $enabled,
          hasstatus  => true,
          hasrestart => true,
          tag        => 'ceilometer-service',
        }
      }
      if $ipmi_namespace {
        service { 'ceilometer-ipmi':
          ensure     => $service_ensure,
          name       => $::ceilometer::params::agent_ipmi_service_name,
          enable     => $enabled,
          hasstatus  => true,
          hasrestart => true,
          tag        => 'ceilometer-service',
        }
      }
    } else {
      service { 'ceilometer-polling':
        ensure     => $service_ensure,
        name       => $::ceilometer::params::agent_polling_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'ceilometer-service',
      }
    }
  }

  if $manage_polling {
    if $polling_config {
      $polling_content = to_yaml($polling_config)
    } else {
      $polling_content = template('ceilometer/polling.yaml.erb')
    }

    file { 'polling':
      ensure  => present,
      path    => $::ceilometer::params::polling,
      content => $polling_content,
      mode    => '0640',
      owner   => 'root',
      group   => $::ceilometer::params::group,
      tag     => 'ceilometer-yamls',
    }

    ceilometer_config {
      'polling/cfg_file': value => $::ceilometer::params::polling;
    }
  } else {
    ceilometer_config {
      'polling/cfg_file': value => $cfg_file;
    }
  }
}
