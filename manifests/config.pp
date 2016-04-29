# == Class: ceilometer::config
#
# This class is used to manage arbitrary ceilometer configurations.
#
# === Parameters
#
# [*ceilometer_config*]
#   (optional) Allow configuration of ceilometer.conf.
#
#   The value is an hash of ceilometer_config resource. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#
#   In yaml format, Example:
#   ceilometer_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*ceilometer_api_paste_ini*]
#   (optional) Allow configuration of /etc/ceilometer/api-paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class ceilometer::config (
  $ceilometer_config           = {},
  $ceilometer_api_paste_ini    = {},
) {

  validate_hash($ceilometer_config)
  validate_hash($ceilometer_api_paste_ini)

  create_resources('ceilometer_config', $ceilometer_config)
  create_resources('ceilometer_api_paste_ini', $ceilometer_api_paste_ini)
}
