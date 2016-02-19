# == Deprecated class: ceilometer::alarm::evaluator
#
# Installs the ceilometer alarm evaluator service
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
# [*evaluation_interval*]
#   (Optional) Define the time interval for the alarm evaluator
#   Defaults to undef.
#
# [*evaluation_service*]
#   (Optional) Define which service use for the evaluator
#   Defaults to undef.
#
# [*partition_rpc_topic*]
#   (Optional) Define which topic the alarm evaluator should access
#   Defaults to undef.
#
# [*record_history*]
#   (Optional) Record alarm change events
#   Defaults to undef.
#
# [*coordination_url*]
#   (Optional) The url to use for distributed group membership coordination.
#   Defaults to undef.
#
class ceilometer::alarm::evaluator (
  $manage_service      = undef,
  $enabled             = undef,
  $evaluation_interval = undef,
  $evaluation_service  = undef,
  $partition_rpc_topic = undef,
  $record_history      = undef,
  $coordination_url    = undef,
) {

  warning('Class is deprecated and will be removed. Use Aodh module to deploy Alarm Evaluator service')

}
