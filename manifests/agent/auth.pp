# == Class: ceilometer::agent::auth
#
# DEPRECATED !
# The ceilometer::agent::auth class helps configure common
# auth settings for the agents.
#
# === Parameters:
#
# [*auth_url*]
#   (Optional) the keystone public endpoint
#   Defaults to undef.
#
# [*auth_region*]
#   (Optional) the keystone region of this node
#   Defaults to undef.
#
# [*auth_user*]
#   (Optional) the keystone user for ceilometer services
#   Defaults to undef.
#
# [*auth_password*]
#   (Required) the keystone password for ceilometer services
#
# [*auth_tenant_name*]
#   (Optional) the keystone tenant name for ceilometer services
#   Defaults to undef.
#
# [*auth_tenant_id*]
#   (Optional) the keystone tenant id for ceilometer services.
#   Defaults to undef.
#
# [*auth_cacert*]
#   (Optional) Certificate chain for SSL validation.
#   Defaults to 'None'.
#
# [*auth_endpoint_type*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to undef.
#
# [*auth_user_domain_name*]
#   (Optional) domain name for auth user.
#   Defaults to undef.
#
# [*auth_project_domain_name*]
#   (Optional) domain name for auth project.
#   Defaults to undef.
#
# [*auth_type*]
#   (Optional) Authentication type to load.
#   Defaults to undef.
#
class ceilometer::agent::auth (
  $auth_password,
  $auth_url                 = undef,
  $auth_region              = undef,
  $auth_user                = undef,
  $auth_tenant_name         = undef,
  $auth_tenant_id           = undef,
  $auth_cacert              = undef,
  $auth_endpoint_type       = undef,
  $auth_user_domain_name    = undef,
  $auth_project_domain_name = undef,
  $auth_type                = undef
) {

  include ceilometer::deps

  warning('The ceilometer::agent::auth class has been deprecated. \
Use the ceilometer::agent::service_credentials classs instead')

  include ceilometer::agent::service_credentials

  # Since we use names instead of ids for keystone credentials in most of
  # our modules, we'll just deprecated this feature and don't migrate this
  # to the new service_credentials class.
  if $auth_tenant_id {
    ceilometer_config {
      'service_credentials/project_id' : value => $auth_tenant_id;
    }
  }
}
