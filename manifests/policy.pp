# == Class: ceilometer::policy
#
# DEPRECATED !!
# Configure the ceilometer policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for ceilometer
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
#   (Optional) Path to the ceilometer policy.json file
#   Defaults to /etc/ceilometer/policy.json
#
class ceilometer::policy (
  $policies    = {},
  $policy_path = '/etc/ceilometer/policy.json',
) {

  include ceilometer::deps
  include ceilometer::params

  warning('The ceilometer::policy class is deprecated and has no effect')

}
