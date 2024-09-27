# == Class: ceilometer
#
#  This class is used to specify configuration parameters that are common
#  across all ceilometer services.
#
# === Parameters:
#
# [*telemetry_secret*]
#   (Required)  Secret key for signing messages.
#
# [*http_timeout*]
#   (Optional) Timeout seconds for HTTP requests.
#   Defaults to $facts['os_service_default']
#
# [*max_parallel_requests*]
#   (Optional) Maximum number of parallel requests for services to handle at
#   the same time.
#   Defaults to $facts['os_service_default']
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*notification_topics*]
#   (Optional) AMQP topic used for OpenStack notifications (list value)
#   Defaults to 'notifications'.
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $facts['os_service_default']
#
# [*notification_retry*]
#   (Optional) The maximum number of attempts to re-sent a notification
#   message, which failed to be delivered due to a recoverable error.
#   Defaults to $facts['os_service_default'].
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'.
#
# [*executor_thread_pool_size*]
#   (optional) Size of executor thread pool when executor is threading or eventlet.
#   Defaults to $facts['os_service_default'].
#
# [*default_transport_url*]
#   (optional) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call.
#   Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_queue*]
#   (Optional) Use quorum queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_transient_quorum_queue*]
#   (Optional) Use quorum queues for transients queues in RabbitMQ.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_delivery_limit*]
#   (Optional) Each time a message is rdelivered to a consumer, a counter is
#   incremented. Once the redelivery count exceeds the delivery limit
#   the message gets dropped or dead-lettered.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_length*]
#   (Optional) Limit the number of messages in the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_quorum_max_memory_bytes*]
#   (Optional) Limit the number of memory bytes used by the quorum queue.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_enable_cancel_on_failover*]
#   (Optional) Enable x-cancel-on-ha-failover flag so that rabbitmq server will
#   cancel and notify consumers when queue is down.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (Optional) Number of seconds after which the Rabbit broker is
#   considered down if heartbeat's keep-alive fails
#   (0 disable the heartbeat). EXPERIMENTAL. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_rate*]
#   (Optional) How often times during the heartbeat_timeout_threshold
#   we check the heartbeat. (integer value)
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
#  [*rabbit_qos_prefetch_count*]
#   (Optional) Specifies the number of messages to prefetch.
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $facts['os_service_default']
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (Optional) SSL version to use (valid only if SSL enabled). '
#   Valid values are TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1,
#   and TLSv1_2 may be available on some distributions. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $facts['os_service_default']
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the ceilometer config.
#   Defaults to false.
#
# [*host*]
#   (Optional) Name of this node. This is typically a hostname, FQDN, or
#   IP address.
#   Defaults to $facts['os_service_default'].
#
class ceilometer(
  $telemetry_secret,
  $http_timeout                       = $facts['os_service_default'],
  $max_parallel_requests              = $facts['os_service_default'],
  $notification_transport_url         = $facts['os_service_default'],
  $notification_topics                = ['notifications'],
  $notification_driver                = $facts['os_service_default'],
  $notification_retry                 = $facts['os_service_default'],
  $package_ensure                     = 'present',
  $executor_thread_pool_size          = $facts['os_service_default'],
  $default_transport_url              = $facts['os_service_default'],
  $rpc_response_timeout               = $facts['os_service_default'],
  $control_exchange                   = $facts['os_service_default'],
  $rabbit_ha_queues                   = $facts['os_service_default'],
  $rabbit_quorum_queue                = $facts['os_service_default'],
  $rabbit_transient_quorum_queue      = $facts['os_service_default'],
  $rabbit_quorum_delivery_limit       = $facts['os_service_default'],
  $rabbit_quorum_max_memory_length    = $facts['os_service_default'],
  $rabbit_quorum_max_memory_bytes     = $facts['os_service_default'],
  $rabbit_enable_cancel_on_failover   = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold = $facts['os_service_default'],
  $rabbit_heartbeat_rate              = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread        = $facts['os_service_default'],
  $rabbit_qos_prefetch_count          = $facts['os_service_default'],
  $amqp_durable_queues                = $facts['os_service_default'],
  $rabbit_use_ssl                     = $facts['os_service_default'],
  $kombu_ssl_ca_certs                 = $facts['os_service_default'],
  $kombu_ssl_certfile                 = $facts['os_service_default'],
  $kombu_ssl_keyfile                  = $facts['os_service_default'],
  $kombu_ssl_version                  = $facts['os_service_default'],
  $kombu_reconnect_delay              = $facts['os_service_default'],
  $kombu_failover_strategy            = $facts['os_service_default'],
  $kombu_compression                  = $facts['os_service_default'],
  Boolean $purge_config               = false,
  $host                               = $facts['os_service_default'],
) {

  include ceilometer::deps
  include ceilometer::params

  package { 'ceilometer-common':
    ensure => $package_ensure,
    name   => $::ceilometer::params::common_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  resources { 'ceilometer_config':
    purge => $purge_config,
  }

  oslo::messaging::rabbit {'ceilometer_config':
    rabbit_ha_queues                => $rabbit_ha_queues,
    heartbeat_timeout_threshold     => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate                  => $rabbit_heartbeat_rate,
    heartbeat_in_pthread            => $rabbit_heartbeat_in_pthread,
    rabbit_qos_prefetch_count       => $rabbit_qos_prefetch_count,
    amqp_durable_queues             => $amqp_durable_queues,
    rabbit_use_ssl                  => $rabbit_use_ssl,
    kombu_ssl_ca_certs              => $kombu_ssl_ca_certs,
    kombu_ssl_certfile              => $kombu_ssl_certfile,
    kombu_ssl_keyfile               => $kombu_ssl_keyfile,
    kombu_ssl_version               => $kombu_ssl_version,
    kombu_reconnect_delay           => $kombu_reconnect_delay,
    kombu_failover_strategy         => $kombu_failover_strategy,
    kombu_compression               => $kombu_compression,
    rabbit_quorum_queue             => $rabbit_quorum_queue,
    rabbit_transient_quorum_queue   => $rabbit_transient_quorum_queue,
    rabbit_quorum_delivery_limit    => $rabbit_quorum_delivery_limit,
    rabbit_quorum_max_memory_length => $rabbit_quorum_max_memory_length,
    rabbit_quorum_max_memory_bytes  => $rabbit_quorum_max_memory_bytes,
    enable_cancel_on_failover       => $rabbit_enable_cancel_on_failover,
  }

  # Once we got here, we can act as an honey badger on the rpc used.
  ceilometer_config {
    'DEFAULT/http_timeout'         : value => $http_timeout;
    'DEFAULT/max_parallel_requests': value => $max_parallel_requests;
    'DEFAULT/host'                 : value => $host;
    'publisher/telemetry_secret'   : value => $telemetry_secret, secret => true;
  }

  oslo::messaging::notifications { 'ceilometer_config':
    transport_url => $notification_transport_url,
    topics        => $notification_topics,
    driver        => $notification_driver,
    retry         => $notification_retry,
  }

  oslo::messaging::default { 'ceilometer_config':
    executor_thread_pool_size => $executor_thread_pool_size,
    transport_url             => $default_transport_url,
    rpc_response_timeout      => $rpc_response_timeout,
    control_exchange          => $control_exchange,
  }
}
