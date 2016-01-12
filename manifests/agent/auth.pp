# == Class: ceilometer::agent::auth
#
# The ceilometer::agent::auth class helps configure common
# auth settings for the agents.
#
# === Parameters:
#
# [*auth_url*]
#   (Optional) the keystone public endpoint
#   Defaults to 'http://localhost:5000/v2.0'.
#
# [*auth_region*]
#   (Optional) the keystone region of this node
#   Defaults to 'RegionOne'.
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
class ceilometer::agent::auth (
  $auth_password,
  $auth_url           = 'http://localhost:5000/v2.0',
  $auth_region        = 'RegionOne',
  $auth_user          = 'ceilometer',
  $auth_tenant_name   = 'services',
  $auth_tenant_id     = undef,
  $auth_cacert        = undef,
  $auth_endpoint_type = undef,
) {

  if ! $auth_cacert {
    ceilometer_config { 'service_credentials/os_cacert': ensure => absent }
  } else {
    ceilometer_config { 'service_credentials/os_cacert': value => $auth_cacert }
  }

  ceilometer_config {
    'service_credentials/os_auth_url'    : value => $auth_url;
    'service_credentials/os_region_name' : value => $auth_region;
    'service_credentials/os_username'    : value => $auth_user;
    'service_credentials/os_password'    : value => $auth_password, secret => true;
    'service_credentials/os_tenant_name' : value => $auth_tenant_name;
  }

  if $auth_tenant_id {
    ceilometer_config {
      'service_credentials/os_tenant_id' : value => $auth_tenant_id;
    }
  }

  if $auth_endpoint_type {
    ceilometer_config {
      'service_credentials/os_endpoint_type' : value => $auth_endpoint_type;
    }
  }

}
