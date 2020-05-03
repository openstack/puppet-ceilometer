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
# DEPRECATED PARAMETERS
#
# [*ceilometer_api_paste_ini*]
#   (optional) Allow configuration of /etc/ceilometer/api_paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class ceilometer::config (
  $ceilometer_config        = {},
  # DEPRECATED PARAMETERS
  $ceilometer_api_paste_ini = undef,
) {

  include ceilometer::deps

  validate_legacy(Hash, 'validate_hash', $ceilometer_config)

  create_resources('ceilometer_config', $ceilometer_config)

  if $ceilometer_api_paste_ini != undef {
    warning('ceilometer_api_paste_ini is deprecated and has no effect.')
  }

}
