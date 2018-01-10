# == Class: ceilometer::policy
#
# Configure the ceilometer policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for ceilometer
#   Example :
#     {
#       'ceilometer-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'ceilometer-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the ceilometer policy.json file
#   Defaults to /etc/ceilometer/policy.json
#
class ceilometer::policy (
  $policies    = {},
  $policy_path = '/etc/ceilometer/policy.json',
) {

  include ::ceilometer::deps
  include ::ceilometer::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::ceilometer::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'ceilometer_config': policy_file => $policy_path }

}
