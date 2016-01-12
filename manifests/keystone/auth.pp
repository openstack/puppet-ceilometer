# == Class: ceilometer::keystone::auth
#
# Configures Ceilometer user, service and endpoint in Keystone.
#
# === Parameters:
#
# [*password*]
#   (Required) Password for Ceilometer user.
#
# [*email*]
#   (Optional) Email for Ceilometer user.
#   Defaults to 'ceilometer@localhost'.
#
# [*auth_name*]
#   (Optional) Username for Ceilometer service.
#   Defaults to 'ceilometer'.
#
# [*configure_endpoint*]
#   (Optional) Should Ceilometer endpoint be configured.
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should Ceilometer service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should roles be configured on Ceilometer service user?
#   Defaults to true.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to value of auth_name.
#
# [*service_type*]
#   (Optional) Type of service. Optional.
#   Defaults to 'metering'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Openstack Metering Service'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*tenant*]
#   (Optional) Tenant for Ceilometer user.
#   Defaults to 'services'.
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8777'.
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8777'.
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8777'.
#
# [*port*]
#   (Optional) DEPRECATED: Use public_url, internal_url and admin_url instead.
#   Setting this parameter overrides public_url, internal_url and admin_url parameters.
#   Default port for endpoints.
#   Defaults to 8777.
#
# [*public_protocol*]
#   (Optional) DEPRECATED: Use public_url instead.
#   Protocol for public endpoint.
#   Setting this parameter overrides public_url parameter.
#   Defaults to 'http'.
#
# [*public_address*]
#   (Optional) DEPRECATED: Use public_url instead.
#   Public address for endpoint.
#   Setting this parameter overrides public_url parameter.
#   Defaults to '127.0.0.1'.
#
# [*internal_protocol*]
#   (Optional) DEPRECATED: Use internal_url instead.
#   Protocol for internal endpoint.
#   Setting this parameter overrides internal_url parameter.
#   Defaults to 'http'.
#
# [*internal_address*]
#   (Optional) DEPRECATED: Use internal_url instead.
#   Internal address for endpoint.
#   Setting this parameter overrides internal_url parameter.
#   Defaults to '127.0.0.1'.
#
# [*admin_protocol*]
#   (Optional) DEPRECATED: Use admin_url instead.
#   Protocol for admin endpoint.
#   Setting this parameter overrides admin_url parameter.
#   Defaults to 'http'.
#
# [*admin_address*]
#   (Optional) DEPRECATED: Use admin_url instead.
#   Admin address for endpoint.
#   Setting this parameter overrides admin_url parameter.
#   Defaults to '127.0.0.1'.
#
# === Deprecation notes:
#
# If any value is provided for public_protocol, public_address or port parameters,
# public_url will be completely ignored. The same applies for internal and admin parameters.
#
# === Examples:
#
#  class { 'ceilometer::keystone::auth':
#    public_url   => 'https://10.0.0.10:8777',
#    internal_url => 'https://10.0.0.11:8777',
#    admin_url    => 'https://10.0.0.11:8777',
#  }
#
class ceilometer::keystone::auth (
  $password             = false,
  $email                = 'ceilometer@localhost',
  $auth_name            = 'ceilometer',
  $configure_user       = true,
  $configure_user_role  = true,
  $service_name         = undef,
  $service_type         = 'metering',
  $service_description  = 'Openstack Metering Service',
  $region               = 'RegionOne',
  $tenant               = 'services',
  $configure_endpoint   = true,
  $public_url           = 'http://127.0.0.1:8777',
  $admin_url            = 'http://127.0.0.1:8777',
  $internal_url         = 'http://127.0.0.1:8777',
  # DEPRECATED PARAMETERS
  $port                 = undef,
  $public_protocol      = undef,
  $public_address       = undef,
  $internal_protocol    = undef,
  $internal_address     = undef,
  $admin_protocol       = undef,
  $admin_address        = undef,
) {

  validate_string($password)

  if $port {
    warning('The port parameter is deprecated, use public_url, internal_url and admin_url instead.')
  }

  if $public_protocol {
    warning('The public_protocol parameter is deprecated, use public_url instead.')
  }

  if $internal_protocol {
    warning('The internal_protocol parameter is deprecated, use internal_url instead.')
  }

  if $admin_protocol {
    warning('The admin_protocol parameter is deprecated, use admin_url instead.')
  }

  if $public_address {
    warning('The public_address parameter is deprecated, use public_url instead.')
  }

  if $internal_address {
    warning('The internal_address parameter is deprecated, use internal_url instead.')
  }

  if $admin_address {
    warning('The admin_address parameter is deprecated, use admin_url instead.')
  }

  $service_name_real = pick($service_name, $auth_name)

  if ($public_protocol or $public_address or $port) {
    $public_url_real = sprintf('%s://%s:%s',
      pick($public_protocol, 'http'),
      pick($public_address, '127.0.0.1'),
      pick($port, '8777'))
  } else {
    $public_url_real = $public_url
  }

  if ($admin_protocol or $admin_address or $port) {
    $admin_url_real = sprintf('%s://%s:%s',
      pick($admin_protocol, 'http'),
      pick($admin_address, '127.0.0.1'),
      pick($port, '8777'))
  } else {
    $admin_url_real = $admin_url
  }

  if ($internal_protocol or $internal_address or $port) {
    $internal_url_real = sprintf('%s://%s:%s',
      pick($internal_protocol, 'http'),
      pick($internal_address, '127.0.0.1'),
      pick($port, '8777'))
  } else {
    $internal_url_real = $internal_url
  }

  ::keystone::resource::service_identity { $auth_name:
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name_real,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => ['admin', 'ResellerAdmin'],
    public_url          => $public_url_real,
    admin_url           => $admin_url_real,
    internal_url        => $internal_url_real,
  }

  if $configure_user_role {
    if !defined(Keystone_role['ResellerAdmin']) {
      keystone_role { 'ResellerAdmin':
        ensure => present,
      }
    }
    Keystone_role['ResellerAdmin'] -> Keystone_user_role["${auth_name}@${tenant}"]
  }

}

