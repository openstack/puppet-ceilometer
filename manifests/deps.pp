# == Class: ceilometer::deps
#
#  Ceilometer anchors and dependency management
#
class ceilometer::deps {

  assert_private()

  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'ceilometer::install::begin': }
  -> Package<| tag == 'ceilometer-package'|>
  ~> anchor { 'ceilometer::install::end': }
  -> anchor { 'ceilometer::config::begin': }
  -> Ceilometer_config<||>
  ~> anchor { 'ceilometer::config::end': }
  -> anchor { 'ceilometer::db::begin': }
  -> anchor { 'ceilometer::db::end': }
  ~> anchor { 'ceilometer::dbsync::begin': }
  -> anchor { 'ceilometer::dbsync::end': }
  ~> anchor { 'ceilometer::service::begin': }
  ~> Service<| tag == 'ceilometer-service' |>
  ~> anchor { 'ceilometer::service::end': }

  # rootwrap config should occur in the config block also.
  Anchor['ceilometer::config::begin']
  -> Ceilometer_rootwrap_config<||>
  ~> Anchor['ceilometer::config::end']

  # Ensure files are modified in the config block
  Anchor['ceilometer::config::begin']
  -> File<| tag == 'ceilometer-yamls' |>
  ~> Anchor['ceilometer::config::end']

  # Installation or config changes will always restart services.
  Anchor['ceilometer::install::end'] ~> Anchor['ceilometer::service::begin']
  Anchor['ceilometer::config::end']  ~> Anchor['ceilometer::service::begin']
}
