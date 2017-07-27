# == Class: ceilometer
#
#  This class is used to specify configuration parameters that are common
#  across all ceilometer services.
#
# === Parameters:
#
# [*http_timeout*]
#   (Optional) Timeout seconds for HTTP requests.
#   Defaults to 600.
#
# [*event_time_to_live*]
#   (Optional) Number of seconds that events are kept in the database for
#   (<= 0 means forever)
#   Defaults to -1.
#
# [*metering_time_to_live*]
#   (Optional) Number of seconds that samples are kept in the database for
#   (<= 0 means forever)
#   Defaults to -1.
#
# [*telemetry_secret*]
#  (Required)  Secret key for signing messages.
#
# [*notification_topics*]
#   (Optional) AMQP topic used for OpenStack notifications (list value)
#   Defaults to 'notifications'.
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $::os_service_default
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'.
#
# [*debug*]
#   (Optional) Should the daemons log debug messages.
#   Defaults to undef.
#
# [*log_dir*]
#   (Optional) Directory to which ceilometer logs are sent.
#   If set to $::os_service_default, it will not log to any directory.
#   Defaults to undef.
#
# [*use_syslog*]
#   (Optional) Use syslog for logging
#   Defaults to undef.
#
# [*use_stderr*]
#   (Optional) Use stderr for logging
#   Defaults to undef.
#
# [*log_facility*]
#   (Optional) Syslog facility to receive log lines.
#   Defaults to undef.
#
# [*default_transport_url*]
#   (optional) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call.
#   Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
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
#  [*rabbit_qos_prefetch_count*]
#   (Optional) Specifies the number of messages to prefetch.
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
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
# [*memcache_servers*]
#   (Optional) A list of memcached server(s) to use for caching. (list value)
#   Defaults to $::os_service_default
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $::os_service_default.
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $::os_service_default.
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $::os_service_default.
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $::os_service_default.
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $::os_service_default.
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default.
#
# [*amqp_allow_insecure_clients*]
#   (Optional) Accept clients using either SSL or plain TCP
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
#
# [*snmpd_readonly_username*]
#   (Optional) User name for snmpd authentication
#   Defaults to $::os_service_default.
#
# [*snmpd_readonly_user_password*]
#   (Optional) Password for snmpd authentication
#   Defaults to $::os_service_default.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the ceilometer config.
#   Defaults to false.
#
# === DEPRECATED PARAMETERS:
#  [*metering_secret*]
#   (optional)  Secret key for signing messages.
#   This option has been renamed to telemetry_secret in Mitaka.
#   Don't define this if using telemetry_secret.
#
# [*alarm_history_time_to_live*]
#
# [*rabbit_host*]
#   (Optional) The RabbitMQ broker address where a single node is used.
#   (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_port*]
#   (Optional) The RabbitMQ broker port where a single node is used.
#   (port value)
#   Defaults to $::os_service_default
#
# [*rabbit_hosts*]
#   (Optional) RabbitMQ HA cluster host:port pairs. (array value)
#   Defaults to $::os_service_default
#
# [*rabbit_userid*]
#   (Optional) The RabbitMQ userid. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_password*]
#   (Optional) The RabbitMQ password. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_virtual_host*]
#   (Optional) The RabbitMQ virtual host. (string value)
#   Defaults to $::os_service_default
#
# [*memcached_servers*]
#   (Optional) A list of memcached server(s) to use for caching. (list value)
#   Defaults to $::os_service_default
#
# [*rpc_backend*]
#   (optional) The messaging driver to use, defaults to rabbit. Other drivers include
#   amqp and zmq. (string value)
#   Default to $::os_service_default
#

class ceilometer(
  $http_timeout                       = '600',
  $event_time_to_live                 = '-1',
  $metering_time_to_live              = '-1',
  $telemetry_secret                   = false,
  $notification_topics                = ['notifications'],
  $notification_driver                = $::os_service_default,
  $package_ensure                     = 'present',
  $debug                              = undef,
  $log_dir                            = undef,
  $use_syslog                         = undef,
  $use_stderr                         = undef,
  $log_facility                       = undef,
  $default_transport_url              = $::os_service_default,
  $rpc_response_timeout               = $::os_service_default,
  $control_exchange                   = $::os_service_default,
  $notification_transport_url         = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_qos_prefetch_count          = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $memcache_servers                   = $::os_service_default,
  $amqp_server_request_prefix         = $::os_service_default,
  $amqp_broadcast_prefix              = $::os_service_default,
  $amqp_group_request_prefix          = $::os_service_default,
  $amqp_container_name                = $::os_service_default,
  $amqp_idle_timeout                  = $::os_service_default,
  $amqp_trace                         = $::os_service_default,
  $amqp_ssl_ca_file                   = $::os_service_default,
  $amqp_ssl_cert_file                 = $::os_service_default,
  $amqp_ssl_key_file                  = $::os_service_default,
  $amqp_ssl_key_password              = $::os_service_default,
  $amqp_allow_insecure_clients        = $::os_service_default,
  $amqp_sasl_mechanisms               = $::os_service_default,
  $amqp_sasl_config_dir               = $::os_service_default,
  $amqp_sasl_config_name              = $::os_service_default,
  $amqp_username                      = $::os_service_default,
  $amqp_password                      = $::os_service_default,
  $snmpd_readonly_username            = $::os_service_default,
  $snmpd_readonly_user_password       = $::os_service_default,
  $purge_config                       = false,
  # DEPRECATED PARAMETERS
  $alarm_history_time_to_live         = undef,
  $metering_secret                    = undef,
  $rabbit_host                        = $::os_service_default,
  $rabbit_port                        = $::os_service_default,
  $rabbit_hosts                       = $::os_service_default,
  $rabbit_userid                      = $::os_service_default,
  $rabbit_password                    = $::os_service_default,
  $rabbit_virtual_host                = $::os_service_default,
  $memcached_servers                  = undef,
  $rpc_backend                        = $::os_service_default,
) {

  include ::ceilometer::deps
  include ::ceilometer::logging
  include ::ceilometer::params

  # Cleanup in Ocata.
  if $telemetry_secret {
    validate_string($telemetry_secret)
    if $metering_secret {
      warning('Both $metering_secret and $telemetry_secret defined, using $telemetry_secret')
    }
    $telemetry_secret_real = $telemetry_secret
  }
  else {
    warning('metering_secret has been renamed to telemetry_secret. metering_secret will continue to work until Ocata.')
    validate_string($metering_secret)
    $telemetry_secret_real = $metering_secret
  }

  if $alarm_history_time_to_live {
    warning('alarm_history_time_to_live parameter is deprecated. It should be configured for Aodh.')
  }

  if !is_service_default($rabbit_host) or
    !is_service_default($rabbit_hosts) or
    !is_service_default($rabbit_password) or
    !is_service_default($rabbit_port) or
    !is_service_default($rabbit_userid) or
    !is_service_default($rabbit_virtual_host) or
    !is_service_default($rpc_backend) {
    warning("ceilometer::rabbit_host, ceilometer::rabbit_hosts, ceilometer::rabbit_password, \
ceilometer::rabbit_port, ceilometer::rabbit_userid, ceilometer::rabbit_virtual_host and \
ceilometer::rpc_backend are deprecated. Please use ceilometer::default_transport_url \
instead.")
  }

  if $memcached_servers {
    warning("memcached_servers parameter is deprecated and will be removed in the future release, \
please use memcache_servers instead.")
    $memcache_servers_real = $memcached_servers
  }
  else {
    $memcache_servers_real = $memcache_servers
  }

  group { 'ceilometer':
    ensure  => present,
    name    => 'ceilometer',
    require => Anchor['ceilometer::install::end'],
  }

  user { 'ceilometer':
    ensure  => present,
    name    => 'ceilometer',
    gid     => 'ceilometer',
    system  => true,
    require => Anchor['ceilometer::install::end'],
  }

  package { 'ceilometer-common':
    ensure => $package_ensure,
    name   => $::ceilometer::params::common_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  resources { 'ceilometer_config':
    purge => $purge_config,
  }


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
    rabbit_qos_prefetch_count   => $rabbit_qos_prefetch_count,
    amqp_durable_queues         => $amqp_durable_queues,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_compression           => $kombu_compression,
  }

  oslo::messaging::amqp { 'ceilometer_config':
    server_request_prefix  => $amqp_server_request_prefix,
    broadcast_prefix       => $amqp_broadcast_prefix,
    group_request_prefix   => $amqp_group_request_prefix,
    container_name         => $amqp_container_name,
    idle_timeout           => $amqp_idle_timeout,
    trace                  => $amqp_trace,
    ssl_ca_file            => $amqp_ssl_ca_file,
    ssl_cert_file          => $amqp_ssl_cert_file,
    ssl_key_file           => $amqp_ssl_key_file,
    ssl_key_password       => $amqp_ssl_key_password,
    allow_insecure_clients => $amqp_allow_insecure_clients,
    sasl_mechanisms        => $amqp_sasl_mechanisms,
    sasl_config_dir        => $amqp_sasl_config_dir,
    sasl_config_name       => $amqp_sasl_config_name,
    username               => $amqp_username,
    password               => $amqp_password,
  }

  # Once we got here, we can act as an honey badger on the rpc used.
  ceilometer_config {
    'DEFAULT/http_timeout'                : value => $http_timeout;
    'publisher/telemetry_secret'          : value => $telemetry_secret_real, secret => true;
    'database/event_time_to_live'         : value => $event_time_to_live;
    'database/metering_time_to_live'      : value => $metering_time_to_live;
    'hardware/readonly_user_name'         : value => $snmpd_readonly_username;
    'hardware/readonly_user_password'     : value => $snmpd_readonly_user_password;
  }

  oslo::messaging::notifications { 'ceilometer_config':
    transport_url => $notification_transport_url,
    topics        => $notification_topics,
    driver        => $notification_driver,
  }

  oslo::messaging::default { 'ceilometer_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::cache { 'ceilometer_config':
    memcache_servers => $memcache_servers_real,
  }
}
