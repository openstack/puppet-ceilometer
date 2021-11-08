# == Class: ceilometer::agent::polling::service_types
#
# Configure service_types parameters
#
# === Parameters
#
# [*glance*]
#   (Optional) glance service type.
#   Defaults to $::os_service_default
#
# [*neutron*]
#   (Optional) neutron service type.
#   Defaults to $::os_service_default
#
# [*nova*]
#   (Optional) nova service type.
#   Defaults to $::os_service_default
#
# [*swift*]
#   (Optional) swift service type.
#   Defaults to $::os_service_default
#
# [*cinder*]
#   (Optional) cinder service type.
#   Defaults to $::os_service_default
#
# [*radosgw*]
#   (Optional) Radosgw service type.
#   Defaults to $::os_service_default
#
class ceilometer::agent::polling::service_types (
  $glance  = $::os_service_default,
  $neutron = $::os_service_default,
  $nova    = $::os_service_default,
  $swift   = $::os_service_default,
  $cinder  = $::os_service_default,
  $radosgw = $::os_service_default,
) {

  include ceilometer::deps

  ceilometer_config {
    'service_types/glance':  value => $glance;
    'service_types/neutron': value => $neutron;
    'service_types/nova':    value => $nova;
    'service_types/swift':   value => $swift;
    'service_types/cinder':  value => $cinder;
    'service_types/radosgw': value => $radosgw;
  }
}
