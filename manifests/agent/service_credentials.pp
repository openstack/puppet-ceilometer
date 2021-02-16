# == Class: ceilometer::agent::service_credentials
#
# The ceilometer::agent::service_credentials class helps configure common
# service credentials settings for the agents.
#
# === Parameters:
#
# [*auth_url*]
#   (Optional) the keystone public endpoint
#   Defaults to 'http://localhost:5000'.
#
# [*region_name*]
#   (Optional) the keystone region of this node
#   Defaults to $::os_service_default.
#
# [*username*]
#   (Optional) the keystone user for ceilometer services
#   Defaults to 'ceilometer'.
#
# [*password*]
#   (Required) the keystone password for ceilometer services
#
# [*project_name*]
#   (Optional) the keystone project name for ceilometer services
#   Defaults to 'services'.
#
# [*cafile*]
#   (Optional) Certificate chain for SSL validation.
#   Defaults to $::os_service_default.
#
# [*interface*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to $::os_service_default.
#
# [*user_domain_name*]
#   (Optional) domain name for auth user.
#   Defaults to 'Default'.
#
# [*project_domain_name*]
#   (Optional) domain name for auth project.
#   Defaults to 'Default'.
#
# [*auth_type*]
#   (Optional) Authentication type to load.
#   Defaults to 'password'.
#
class ceilometer::agent::service_credentials (
  $password            = false,
  $auth_url            = 'http://localhost:5000',
  $region_name         = $::os_service_default,
  $username            = 'ceilometer',
  $project_name        = 'services',
  $cafile              = $::os_service_default,
  $interface           = $::os_service_default,
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $auth_type           = 'password',
) {

  include ceilometer::deps

  $password_real = pick($::ceilometer::agent::auth::auth_password, $password)
  if ! $password_real {
    fail('The password parameter is required')
  }

  $auth_url_real = pick($::ceilometer::agent::auth::auth_url, $auth_url)
  $region_name_real = pick($::ceilometer::agent::auth::auth_region, $region_name)
  $username_real = pick($::ceilometer::agent::auth::auth_user, $username)
  $project_name_real = pick($::ceilometer::agent::auth::auth_tenant_name, $project_name)
  $cafile_real = pick($::ceilometer::agent::auth::auth_cacert, $cafile)
  $interface_real = pick($::ceilometer::agent::auth::auth_endpoint_type, $interface)
  $user_domain_name_real = pick($::ceilometer::agent::auth::auth_user_domain_name, $user_domain_name)
  $project_domain_name_real = pick($::ceilometer::agent::auth::auth_project_domain_name, $project_domain_name)
  $auth_type_real = pick($::ceilometer::agent::auth::auth_type, $auth_type)

  ceilometer_config {
    'service_credentials/auth_url'           : value => $auth_url_real;
    'service_credentials/region_name'        : value => $region_name_real;
    'service_credentials/username'           : value => $username_real;
    'service_credentials/password'           : value => $password_real, secret => true;
    'service_credentials/project_name'       : value => $project_name_real;
    'service_credentials/cafile'             : value => $cafile_real;
    'service_credentials/interface'          : value => $interface_real;
    'service_credentials/user_domain_name'   : value => $user_domain_name_real;
    'service_credentials/project_domain_name': value => $project_domain_name_real;
    'service_credentials/auth_type'          : value => $auth_type_real;
  }
}
