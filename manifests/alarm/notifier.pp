# == Deprecated class: ceilometer::alarm::notifier
#
# Installs the ceilometer alarm notifier service
#
# === Parameters:
#
# [*enabled*]
#   (Optional) Should the service be enabled.
#   Defaults to undef.
#
# [*manage_service*]
#   (Optional) Whether the service should be managed by Puppet.
#   Defaults to undef.
#
# [*notifier_rpc_topic*]
#   (Optional) Define on which topic the notifier will have access.
#   Defaults to undef.
#
# [*rest_notifier_certificate_key*]
#   (Optional) Define the certificate key for the rest service.
#   Defaults to undef.
#
# [*rest_notifier_certificate_file*]
#   (optional) Define the certificate file for the rest service.
#   Defaults to undef.
#
# [*rest_notifier_ssl_verify*]
#   (optional) Should the ssl verify parameter be enabled.
#   Defaults to undef.
#
class ceilometer::alarm::notifier (
  $manage_service                 = undef,
  $enabled                        = undef,
  $notifier_rpc_topic             = undef,
  $rest_notifier_certificate_key  = undef,
  $rest_notifier_certificate_file = undef,
  $rest_notifier_ssl_verify       = undef,
) {

  warning('Class is deprecated and will be removed. Use Aodh module to deploy Alarm Notifier service')

}
