# == Class: ceilometer::agent::polling::rgw
#
# Configure rgw parameters
#
# === Parameters
#
# [*access_key*]
#  (Optional) Access key for Radosgw Admin.
#  Defaults to $facts['os_service_default']
#
# [*secret_key*]
#  (Optional) Secret key for Radosgw Admin.
#  Defaults to $facts['os_service_default']
#
# [*implicit_tenants*]
#  (Optional) Whether RGW uses implicit tenants or not.
#  Defaults to $facts['os_service_default']
#
class ceilometer::agent::polling::rgw (
  $access_key       = $facts['os_service_default'],
  $secret_key       = $facts['os_service_default'],
  $implicit_tenants = $facts['os_service_default'],
) {
  include ceilometer::deps

  ceilometer_config {
    'rgw_admin_credentials/access_key': value => $access_key, secret => true;
    'rgw_admin_credentials/secret_key': value => $secret_key, secret => true;
    'rgw_client/implicit_tenants':      value => $implicit_tenants;
  }
}
