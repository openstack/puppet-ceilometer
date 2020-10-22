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
# [*configure_user*]
#   (Optional) Should Ceilometer service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should roles be configured on Ceilometer service user?
#   Defaults to true.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*tenant*]
#   (Optional) Tenant for Ceilometer user.
#   Defaults to 'services'.
#
# DEPRECATED PARAMETERS
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to undef
#
# [*service_type*]
#   (Optional) Type of service. Optional.
#   Defaults to undef
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to undef
#
# [*configure_endpoint*]
#   (Optional) Should Ceilometer endpoint be configured.
#   Defaults to undef
#
# [*configure_service*]
#   (Optional) Whether to create the service.
#   Default to undef
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to undef
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to undef
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to undef
#
# === Examples:
#
#  class { 'ceilometer::keystone::auth':
#    password => 'secrete',
#  }
#
class ceilometer::keystone::auth (
  $password             = false,
  $email                = 'ceilometer@localhost',
  $auth_name            = 'ceilometer',
  $configure_user       = true,
  $configure_user_role  = true,
  $region               = 'RegionOne',
  $tenant               = 'services',
  # DEPRECATED PARAMETERS
  $service_name         = undef,
  $service_type         = undef,
  $service_description  = undef,
  Optional[Boolean] $configure_service = undef,
  $configure_endpoint   = undef,
  $public_url           = undef,
  $admin_url            = undef,
  $internal_url         = undef,
) {

  include ceilometer::deps

  validate_legacy(String, 'validate_string', $password)

  if $service_name != undef or $service_type != undef or $service_description != undef {
    warning('The parameters for keystone service record have been deprecated and have no effect')
  }

  if $configure_endpoint != undef {
    warning('The configure_endpoint parameter has been deprecated and has no effect')
  }

  if $configure_service != undef {
    warning('The configure_service parameter has been deprecated and has no effect')
  }

  if $public_url != undef or $admin_url != undef or $internal_url != undef {
    warning('The parameters for keystone endpoint record have been deprecated and have no effect')
  }

  # Ceilometer rquires only its user, project, and role assignment.
  # service and endpoint should be disabled since ceilometer-api has been removed.
  keystone::resource::service_identity { 'ceilometer':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => false,
    configure_service   => false,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => ['admin', 'ResellerAdmin'],
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
