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
# [*roles*]
#   (Optional) List of roles assigned to ceilometer user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to ceilometer user.
#   Defaults to []
#
# === Examples:
#
#  class { 'ceilometer::keystone::auth':
#    password => 'secrete',
#  }
#
class ceilometer::keystone::auth (
  String[1] $password,
  $email               = 'ceilometer@localhost',
  $auth_name           = 'ceilometer',
  $configure_user      = true,
  $configure_user_role = true,
  $region              = 'RegionOne',
  $tenant              = 'services',
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
) {

  include ceilometer::deps

  # Ceilometer requires only its user, project, and role assignment.
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
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
  }
}
