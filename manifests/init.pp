# == Class: ceilometer
#
#  This class is used to specify configuration parameters that are common
#  across all ceilometer services.
#
# === Parameters:
#
# [*http_timeout*]
#   (Optional) Timeout seconds for HTTP requests.
#   Defaults to $::os_service_default
#
# [*max_parallel_requests*]
#   (Optional) Maximum number of parallel requests for services to handle at
#   the same time.
#   Defaults to $::os_service_default
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
# [*executor_thread_pool_size*]
#   (optional) Size of executor thread pool when executor is threading or eventlet.
#   Defaults to $::os_service_default.
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
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
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
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
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
# [*amqp_rpc_address_prefix*]
#   (Optional) Address prefix for Ceilometer generated RPC addresses
#   Defaults to $::os_service_default.
#
# [*amqp_notify_address_prefix*]
#   (Optional) Address prefix for Ceilometer generated Notification addresses
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
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the ceilometer config.
#   Defaults to false.
#
# [*host*]
#   (Optional) Name of this node. This is typically a hostname, FQDN, or
#   IP address.
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*cache_backend*]
#   (Optional) The backend to pass to oslo::cache.
#   Defaults to undef.
#
# [*memcache_servers*]
#   (Optional) A list of memcached server(s) to use for caching. (list value)
#   Defaults to undef
#
# [*cache_enable_socket_keepalive*]
#   (Optional) Global toggle for the socket keepalive of dogpile's
#   pymemcache backend
#   Defaults to undef
#
# [*cache_socket_keepalive_idle*]
#   (Optional) The time (in seconds) the connection needs to remain idle
#   before TCP starts sending keepalive probes. Should be a positive integer
#   most greater than zero.
#   Defaults to undef
#
# [*cache_socket_keepalive_interval*]
#   (Optional) The time (in seconds) between individual keepalive probes.
#   Should be a positive integer most greater than zero.
#   Defaults to undef
#
# [*cache_socket_keepalive_count*]
#   (Optional) The maximum number of keepalive probes TCP should send before
#   dropping the connection. Should be a positive integer most greater than
#   zero.
#   Defaults to undef
#
# [*cache_tls_enabled*]
#   (Optional) Global toggle for TLS usage when communicating with
#   the caching servers.
#   Default to undef
#
# [*cache_tls_cafile*]
#   (Optional) Path to a file of concatenated CA certificates in PEM
#   format necessary to establish the caching server's authenticity.
#   If tls_enabled is False, this option is ignored.
#   Default to undef
#
# [*cache_tls_certfile*]
#   (Optional) Path to a single file in PEM format containing the
#   client's certificate as well as any number of CA certificates
#   needed to establish the certificate's authenticity. This file
#   is only required when client side authentication is necessary.
#   If tls_enabled is False, this option is ignored.
#   Default to undef
#
# [*cache_tls_keyfile*]
#   (Optional) Path to a single file containing the client's private
#   key in. Otherwise the private key will be taken from the file
#   specified in tls_certfile. If tls_enabled is False, this option
#   is ignored.
#   Default to undef
#
# [*cache_tls_allowed_ciphers*]
#   (Optional) Set the available ciphers for sockets created with
#   the TLS context. It should be a string in the OpenSSL cipher
#   list format. If not specified, all OpenSSL enabled ciphers will
#   be available.
#   Default to undef
#
# [*cache_enable_retry_client*]
#   (Optional) Enable retry client mechanisms to handle failure.
#   Those mechanisms can be used to wrap all kind of pymemcache
#   clients. The wrapper allows you to define how many attempts
#   to make and how long to wait between attempts.
#   Default to undef
#
# [*cache_retry_attempts*]
#   (Optional) Number of times to attempt an action before failing.
#   Default to undef
#
# [*cache_retry_delay*]
#   (Optional) Number of seconds to sleep between each attempt.
#   Default to undef
#
# [*cache_hashclient_retry_attempts*]
#   (Optional) Amount of times a client should be tried
#   before it is marked dead and removed from the pool in
#   the HashClient's internal mechanisms.
#   Default to undef
#
# [*cache_hashclient_retry_delay*]
#   (Optional) Time in seconds that should pass between
#   retry attempts in the HashClient's internal mechanisms.
#   Default to undef
#
# [*cache_dead_timeout*]
#   (Optional) Time in seconds before attempting to add a node
#   back in the pool in the HashClient's internal mechanisms.
#   Default to undef
#
# [*manage_backend_package*]
#   (Optional) If we should install the cache backend package.
#   Defaults to undef
#
# [*snmpd_readonly_username*]
#   (Optional) User name for snmpd authentication
#   Defaults to undef
#
# [*snmpd_readonly_user_password*]
#   (Optional) Password for snmpd authentication
#   Defaults to undef
#
class ceilometer(
  $http_timeout                       = $::os_service_default,
  $max_parallel_requests              = $::os_service_default,
  $telemetry_secret                   = false,
  $notification_topics                = ['notifications'],
  $notification_driver                = $::os_service_default,
  $package_ensure                     = 'present',
  $executor_thread_pool_size          = $::os_service_default,
  $default_transport_url              = $::os_service_default,
  $rpc_response_timeout               = $::os_service_default,
  $control_exchange                   = $::os_service_default,
  $notification_transport_url         = $::os_service_default,
  $rabbit_ha_queues                   = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold = $::os_service_default,
  $rabbit_heartbeat_rate              = $::os_service_default,
  $rabbit_heartbeat_in_pthread        = $::os_service_default,
  $rabbit_qos_prefetch_count          = $::os_service_default,
  $amqp_durable_queues                = $::os_service_default,
  $rabbit_use_ssl                     = $::os_service_default,
  $kombu_ssl_ca_certs                 = $::os_service_default,
  $kombu_ssl_certfile                 = $::os_service_default,
  $kombu_ssl_keyfile                  = $::os_service_default,
  $kombu_ssl_version                  = $::os_service_default,
  $kombu_reconnect_delay              = $::os_service_default,
  $kombu_failover_strategy            = $::os_service_default,
  $kombu_compression                  = $::os_service_default,
  $amqp_server_request_prefix         = $::os_service_default,
  $amqp_broadcast_prefix              = $::os_service_default,
  $amqp_group_request_prefix          = $::os_service_default,
  $amqp_container_name                = $::os_service_default,
  $amqp_idle_timeout                  = $::os_service_default,
  $amqp_trace                         = $::os_service_default,
  $amqp_rpc_address_prefix            = $::os_service_default,
  $amqp_notify_address_prefix         = $::os_service_default,
  $amqp_ssl_ca_file                   = $::os_service_default,
  $amqp_ssl_cert_file                 = $::os_service_default,
  $amqp_ssl_key_file                  = $::os_service_default,
  $amqp_ssl_key_password              = $::os_service_default,
  $amqp_sasl_mechanisms               = $::os_service_default,
  $amqp_sasl_config_dir               = $::os_service_default,
  $amqp_sasl_config_name              = $::os_service_default,
  $amqp_username                      = $::os_service_default,
  $amqp_password                      = $::os_service_default,
  $purge_config                       = false,
  $host                               = $::os_service_default,
  # DEPRECATED PARAMETERS
  $cache_backend                      = undef,
  $memcache_servers                   = undef,
  $cache_enable_socket_keepalive      = undef,
  $cache_socket_keepalive_idle        = undef,
  $cache_socket_keepalive_interval    = undef,
  $cache_socket_keepalive_count       = undef,
  $cache_tls_enabled                  = undef,
  $cache_tls_cafile                   = undef,
  $cache_tls_certfile                 = undef,
  $cache_tls_keyfile                  = undef,
  $cache_tls_allowed_ciphers          = undef,
  $cache_enable_retry_client          = undef,
  $cache_retry_attempts               = undef,
  $cache_retry_delay                  = undef,
  $cache_hashclient_retry_attempts    = undef,
  $cache_hashclient_retry_delay       = undef,
  $cache_dead_timeout                 = undef,
  $manage_backend_package             = undef,
  $snmpd_readonly_username            = undef,
  $snmpd_readonly_user_password       = undef,
) {

  include ceilometer::deps
  include ceilometer::params

  [
    'cache_backend',
    'memcache_servers',
    'cache_enable_socket_keepalive',
    'cache_socket_keepalive_idle',
    'cache_socket_keepalive_interval',
    'cache_socket_keepalive_count',
    'cache_tls_enabled',
    'cache_tls_cafile',
    'cache_tls_certfile',
    'cache_tls_keyfile',
    'cache_tls_allowed_ciphers',
    'cache_enable_retry_client',
    'cache_retry_attempts',
    'cache_retry_delay',
    'cache_hashclient_retry_attempts',
    'cache_hashclient_retry_delay',
    'cache_dead_timeout',
    'manage_backend_package'
  ].each |String $cache_opt| {
    if getvar($cache_opt) != undef {
      warning("The ceilometer::${cache_opt} parameter is deprecated. Use the ceilometer::cache class")
    }
  }
  include ceilometer::cache

  if $snmpd_readonly_username != undef or $snmpd_readonly_user_password != undef {
    warning('The snmpd_readonly_* parameters have been deprecated.')
  }
  $snmpd_readonly_username_real = pick($snmpd_readonly_username, $::os_service_default)
  $snmpd_readonly_user_password_real = pick($snmpd_readonly_user_password, $::os_service_default)

  package { 'ceilometer-common':
    ensure => $package_ensure,
    name   => $::ceilometer::params::common_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  resources { 'ceilometer_config':
    purge => $purge_config,
  }

  oslo::messaging::rabbit {'ceilometer_config':
    rabbit_ha_queues            => $rabbit_ha_queues,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    heartbeat_in_pthread        => $rabbit_heartbeat_in_pthread,
    rabbit_qos_prefetch_count   => $rabbit_qos_prefetch_count,
    amqp_durable_queues         => $amqp_durable_queues,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_failover_strategy     => $kombu_failover_strategy,
    kombu_compression           => $kombu_compression,
  }

  oslo::messaging::amqp { 'ceilometer_config':
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    rpc_address_prefix    => $amqp_rpc_address_prefix,
    notify_address_prefix => $amqp_notify_address_prefix,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
    username              => $amqp_username,
    password              => $amqp_password,
  }

  # Once we got here, we can act as an honey badger on the rpc used.
  ceilometer_config {
    'DEFAULT/http_timeout'           : value => $http_timeout;
    'DEFAULT/max_parallel_requests'  : value => $max_parallel_requests;
    'DEFAULT/host'                   : value => $host;
    'publisher/telemetry_secret'     : value => $telemetry_secret, secret => true;
    'hardware/readonly_user_name'    : value => $snmpd_readonly_username_real;
    'hardware/readonly_user_password': value => $snmpd_readonly_user_password_real, secret => true;
  }

  oslo::messaging::notifications { 'ceilometer_config':
    transport_url => $notification_transport_url,
    topics        => $notification_topics,
    driver        => $notification_driver,
  }

  oslo::messaging::default { 'ceilometer_config':
    executor_thread_pool_size => $executor_thread_pool_size,
    transport_url             => $default_transport_url,
    rpc_response_timeout      => $rpc_response_timeout,
    control_exchange          => $control_exchange,
  }
}
