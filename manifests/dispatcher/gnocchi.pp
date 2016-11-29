# == Class: ceilometer::dispatcher::gnocchi
#
# Configure Gnocchi dispatcher for Ceilometer
#
# === Parameters:
#
# [*filter_service_activity*]
#   (Optional) Filter out samples generated by Gnocchi service activity.
#   Defaults to $::os_service_default.
#
# [*filter_project*]
#   (Optional) Gnocchi project used to filter out samples
#   generated by Gnocchi service activity
#   Defaults to $::os_service_default.
#
# [*url*]
#   (Optional) Gnocchi URL
#   Defaults to $::os_service_default.
#
# [*archive_policy*]
#   (Optional) The archive policy to use when the dispatcher
#   Defaults to $::os_service_default.
#
# [*resources_definition_file*]
#   (Optional) The Yaml file that defines mapping between samples
#   and gnocchi resources/metrics.
#   Defaults to $::os_service_default.
#
class ceilometer::dispatcher::gnocchi (
  $filter_service_activity   = $::os_service_default,
  $filter_project            = $::os_service_default,
  $url                       = $::os_service_default,
  $archive_policy            = $::os_service_default,
  $resources_definition_file = $::os_service_default,
) {

  include ::ceilometer::deps

  ceilometer_config {
    'dispatcher_gnocchi/filter_service_activity':   value => $filter_service_activity;
    'dispatcher_gnocchi/filter_project':            value => $filter_project;
    'dispatcher_gnocchi/url':                       value => $url;
    'dispatcher_gnocchi/archive_policy':            value => $archive_policy;
    'dispatcher_gnocchi/resources_definition_file': value => $resources_definition_file;
  }

}
