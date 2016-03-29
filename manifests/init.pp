# == Class: ceilometer
#
#  This class is used to specify configuration parameters that are common
#  across all ceilometer services.
#
# === Parameters:
#
#  [*http_timeout*]
#    (Optional) Timeout seconds for HTTP requests.
#    Defaults to 600.
#
#  [*event_time_to_live*]
#    (Optional) Number of seconds that events are kept in the database for
#    (<= 0 means forever)
#    Defaults to -1.
#
#  [*metering_time_to_live*]
#    (Optional) Number of seconds that samples are kept in the database for
#    (<= 0 means forever)
#    Defaults to -1.
#
#  [*metering_secret*]
#   (Required)  Secret key for signing messages.
#
#  [*notification_topics*]
#    (Optional) AMQP topic used for OpenStack notifications (list value)
#    Defaults to 'notifications'.
#
#  [*package_ensure*]
#    (Optional) ensure state for package.
#    Defaults to 'present'.
#
#  [*debug*]
#    (Optional) Should the daemons log debug messages.
#    Defaults to undef.
#
#  [*log_dir*]
#    (Optional) Directory to which ceilometer logs are sent.
#    If set to boolean false, it will not log to any directory.
#    Defaults to undef.
#
#  [*verbose*]
#    (Optional) should the daemons log verbose messages.
#    Defaults to undef.
#
#  [*use_syslog*]
#    (Optional) Use syslog for logging
#    Defaults to undef.
#
#  [*use_stderr*]
#    (Optional) Use stderr for logging
#    Defaults to undef.
#
#  [*log_facility*]
#    (Optional) Syslog facility to receive log lines.
#    Defaults to undef.
#
#  [*rpc_backend*]
#    The messaging driver to use, defaults to rabbit. Other drivers include
#    amqp and zmq. (string value)
#    Default to $::os_service_default
#
#  [*rabbit_host*]
#   (Optional) The RabbitMQ broker address where a single node is used.
#   (string value)
#   Defaults to $::os_service_default
#
#  [*rabbit_port*]
#   (Optional) The RabbitMQ broker port where a single node is used.
#   (port value)
#   Defaults to $::os_service_default
#
#  [*rabbit_hosts*]
#   (Optional) RabbitMQ HA cluster host:port pairs. (array value)
#   Defaults to $::os_service_default
#
#  [*rabbit_userid*]
#   (Optional) The RabbitMQ userid. (string value)
#   Defaults to $::os_service_default
#
#  [*rabbit_password*]
#   (Optional) The RabbitMQ password. (string value)
#   Defaults to $::os_service_default
#
#  [*rabbit_virtual_host*]
#   (Optional) The RabbitMQ virtual host. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (Optional) Number of seconds after which the Rabbit broker is
#   considered down if heartbeat's keep-alive fails
#   (0 disable the heartbeat). EXPERIMENTAL. (integer value)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (Optional) How often times during the heartbeat_timeout_threshold
#   we check the heartbeat. (integer value)
#   Defaults to $::os_service_default
#
#  [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
#  [*amqp_durable_queues*]
#    (optional) Define queues as "durable" to rabbitmq.
#    Defaults to $::os_service_default
#
#  [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $::os_service_default
#
#  [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
#  [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
#  [*kombu_ssl_version*]
#   (Optional) SSL version to use (valid only if SSL enabled). '
#   Valid values are TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1,
#   and TLSv1_2 may be available on some distributions. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
#  [*memcached_servers*]
#    (Optional) A list of memcached server(s) to use for caching. (list value)
#    Defaults to $::os_service_default
#
# === DEPRECATED PARAMETERS:
#
# [*alarm_history_time_to_live*]
# [*qpid_hostname*]
# [*qpid_port*]
# [*qpid_username*]
# [*qpid_password*]
# [*qpid_heartbeat*]
# [*qpid_protocol*]
# [*qpid_tcp_nodelay*]
# [*qpid_reconnect*]
# [*qpid_reconnect_timeout*]
# [*qpid_reconnect_limit*]
# [*qpid_reconnect_interval*]
# [*qpid_reconnect_interval_min*]
# [*qpid_reconnect_interval_max*]
#
class ceilometer(
  $http_timeout                       = '600',
  $event_time_to_live                 = '-1',
  $metering_time_to_live              = '-1',
  $metering_secret                    = false,
  $notification_topics                = ['notifications'],
  $package_ensure                     = 'present',
  $debug                              = undef,
  $log_dir                            = undef,
  $verbose                            = undef,
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_facility                       = undef,
  $rpc_backend                        = $::os_service_default,
  $rabbit_host                        = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $memcached_servers                  = $::os_service_default,
  # DEPRECATED PARAMETERS
  $alarm_history_time_to_live         = undef,
  $qpid_hostname                      = undef,
  $qpid_port                          = undef,
  $qpid_username                      = undef,
  $qpid_password                      = undef,
  $qpid_heartbeat                     = undef,
  $qpid_protocol                      = undef,
  $qpid_tcp_nodelay                   = undef,
  $qpid_reconnect                     = undef,
  $qpid_reconnect_timeout             = undef,
  $qpid_reconnect_limit               = undef,
  $qpid_reconnect_interval_min        = undef,
  $qpid_reconnect_interval_max        = undef,
  $qpid_reconnect_interval            = undef,
) {

  validate_string($metering_secret)

  include ::ceilometer::logging
  include ::ceilometer::params

  if $alarm_history_time_to_live {
    warning('alarm_history_time_to_live parameter is deprecated. It should be configured for Aodh.')
  }

  group { 'ceilometer':
    name    => 'ceilometer',
    require => Package['ceilometer-common'],
  }

  user { 'ceilometer':
    name    => 'ceilometer',
    gid     => 'ceilometer',
    system  => true,
    require => Package['ceilometer-common'],
  }

  package { 'ceilometer-common':
    ensure => $package_ensure,
    name   => $::ceilometer::params::common_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  # we keep "ceilometer.openstack.common.rpc.impl_kombu" for backward compatibility
  if $rpc_backend in [$::os_service_default, 'ceilometer.openstack.common.rpc.impl_kombu', 'rabbit'] {
    oslo::messaging::rabbit {'ceilometer_config':
      rabbit_host                 => $rabbit_host,
      rabbit_port                 => $rabbit_port,
      rabbit_hosts                => $rabbit_hosts,
      rabbit_userid               => $rabbit_userid,
      rabbit_password             => $rabbit_password,
      rabbit_virtual_host         => $rabbit_virtual_host,
      rabbit_ha_queues            => $rabbit_ha_queues,
      heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
      heartbeat_rate              => $rabbit_heartbeat_rate,
      amqp_durable_queues         => $amqp_durable_queues,
      rabbit_use_ssl              => $rabbit_use_ssl,
      kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
      kombu_ssl_certfile          => $kombu_ssl_certfile,
      kombu_ssl_keyfile           => $kombu_ssl_keyfile,
      kombu_ssl_version           => $kombu_ssl_version,
      kombu_reconnect_delay       => $kombu_reconnect_delay,
      kombu_compression           => $kombu_compression,
    }
  } else {
    nova_config { 'DEFAULT/rpc_backend': value => $rpc_backend }
  }

  # Once we got here, we can act as an honey badger on the rpc used.
  ceilometer_config {
    'DEFAULT/http_timeout'                : value => $http_timeout;
    'publisher/metering_secret'           : value => $metering_secret, secret => true;
    'database/event_time_to_live'         : value => $event_time_to_live;
    'database/metering_time_to_live'      : value => $metering_time_to_live;
  }

  oslo::messaging::notifications { 'ceilometer_config': topics => $notification_topics }

  oslo::cache { 'ceilometer_config':
    memcache_servers => $memcached_servers,
  }
}
