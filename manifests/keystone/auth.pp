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
#   Defaults to 'ceilometer'.
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
  $service_name         = 'ceilometer',
  $service_type         = 'metering',
  $service_description  = 'Openstack Metering Service',
  $region               = 'RegionOne',
  $tenant               = 'services',
  $configure_endpoint   = true,
  $public_url           = 'http://127.0.0.1:8777',
  $admin_url            = 'http://127.0.0.1:8777',
  $internal_url         = 'http://127.0.0.1:8777',
) {

  include ::ceilometer::deps

  validate_string($password)

  ::keystone::resource::service_identity { 'ceilometer':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => ['admin', 'ResellerAdmin'],
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
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

