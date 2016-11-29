# == Class: ceilometer::agent::auth
#
# The ceilometer::agent::auth class helps configure common
# auth settings for the agents.
#
# === Parameters:
#
# [*auth_url*]
#   (Optional) the keystone public endpoint
#   Defaults to 'http://localhost:5000'.
#
# [*auth_region*]
#   (Optional) the keystone region of this node
#   Defaults to $::os_service_default.
#
# [*auth_user*]
#   (Optional) the keystone user for ceilometer services
#   Defaults to 'ceilometer'.
#
# [*auth_password*]
#   (Required) the keystone password for ceilometer services
#
# [*auth_tenant_name*]
#   (Optional) the keystone tenant name for ceilometer services
#   Defaults to 'services'.
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
#   Defaults to 'Default'.
#
# [*auth_project_domain_name*]
#   (Optional) domain name for auth project.
#   Defaults to 'Default'.
#
# [*auth_type*]
#   (Optional) Authentication type to load.
#   Defaults to 'password'.
#
class ceilometer::agent::auth (
  $auth_password,
  $auth_url                 = 'http://localhost:5000',
  $auth_region              = $::os_service_default,
  $auth_user                = 'ceilometer',
  $auth_tenant_name         = 'services',
  $auth_tenant_id           = undef,
  $auth_cacert              = undef,
  $auth_endpoint_type       = undef,
  $auth_user_domain_name    = 'Default',
  $auth_project_domain_name = 'Default',
  $auth_type                = 'password',
) {

  include ::ceilometer::deps

  if ! $auth_cacert {
    ceilometer_config { 'service_credentials/ca_file': ensure => absent }
  } else {
    ceilometer_config { 'service_credentials/ca_file': value => $auth_cacert }
  }

  ceilometer_config {
    'service_credentials/auth_url'           : value => $auth_url;
    'service_credentials/region_name'        : value => $auth_region;
    'service_credentials/username'           : value => $auth_user;
    'service_credentials/password'           : value => $auth_password, secret => true;
    'service_credentials/project_name'       : value => $auth_tenant_name;
    'service_credentials/user_domain_name'   : value => $auth_user_domain_name;
    'service_credentials/project_domain_name': value => $auth_project_domain_name;
    'service_credentials/auth_type'          : value => $auth_type;
  }

  if $auth_tenant_id {
    ceilometer_config {
      'service_credentials/project_id' : value => $auth_tenant_id;
    }
  }

  if $auth_endpoint_type {
    ceilometer_config {
      'service_credentials/interface' : value => $auth_endpoint_type;
    }
  }
}
