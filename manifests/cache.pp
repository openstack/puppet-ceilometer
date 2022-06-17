# Class ceilometer::cache
#
#  ceilometer cache configuration
#
# == parameters
#
# [*config_prefix*]
#   (Optional) Prefix for building the configuration dictionary for
#   the cache region. This should not need to be changed unless there
#   is another dogpile.cache region with the same configuration name.
#   (string value)
#   Defaults to $::os_service_default
#
# [*expiration_time*]
#   (Optional) Default TTL, in seconds, for any cached item in the
#   dogpile.cache region. This applies to any cached method that
#   doesn't have an explicit cache expiration time defined for it.
#   (integer value)
#   Defaults to $::os_service_default
#
# [*backend*]
#   (Optional) Dogpile.cache backend module. It is recommended that
#   Memcache with pooling (oslo_cache.memcache_pool) or Redis
#   (dogpile.cache.redis) be used in production deployments. (string value)
#   Defaults to $::os_service_default
#
# [*backend_argument*]
#   (Optional) Arguments supplied to the backend module. Specify this option
#   once per argument to be passed to the dogpile.cache backend.
#   Example format: "<argname>:<value>". (list value)
#   Defaults to $::os_service_default
#
# [*proxies*]
#   (Optional) Proxy classes to import that will affect the way the
#   dogpile.cache backend functions. See the dogpile.cache documentation on
#   changing-backend-behavior. (list value)
#   Defaults to $::os_service_default
#
# [*enabled*]
#   (Optional) Global toggle for caching. (boolean value)
#   Defaults to $::os_service_default
#
# [*debug_cache_backend*]
#   (Optional) Extra debugging from the cache backend (cache keys,
#   get/set/delete/etc calls). This is only really useful if you need
#   to see the specific cache-backend get/set/delete calls with the keys/values.
#   Typically this should be left set to false. (boolean value)
#   Defaults to $::os_service_default
#
# [*memcache_servers*]
#   (Optional) Memcache servers in the format of "host:port".
#   (dogpile.cache.memcache and oslo_cache.memcache_pool backends only).
#   (list value)
#   Defaults to $::os_service_default
#
# [*memcache_dead_retry*]
#   (Optional) Number of seconds memcached server is considered dead before
#   it is tried again. (dogpile.cache.memcache and oslo_cache.memcache_pool
#   backends only). (integer value)
#   Defaults to $::os_service_default
#
# [*memcache_socket_timeout*]
#   (Optional) Timeout in seconds for every call to a server.
#   (dogpile.cache.memcache and oslo_cache.memcache_pool backends only).
#   (floating point value)
#   Defaults to $::os_service_default
#
# [*enable_socket_keepalive*]
#   (Optional) Global toggle for the socket keepalive of dogpile's
#   pymemcache backend
#   Defaults to $::os_service_default
#
# [*socket_keepalive_idle*]
#   (Optional) The time (in seconds) the connection needs to remain idle
#   before TCP starts sending keepalive probes. Should be a positive integer
#   most greater than zero.
#   Defaults to $::os_service_default
#
# [*socket_keepalive_interval*]
#   (Optional) The time (in seconds) between individual keepalive probes.
#   Should be a positive integer most greater than zero.
#   Defaults to $::os_service_default
#
# [*socket_keepalive_count*]
#   (Optional) The maximum number of keepalive probes TCP should send before
#   dropping the connection. Should be a positive integer most greater than
#   zero.
#   Defaults to $::os_service_default
#
# [*memcache_pool_maxsize*]
#   (Optional) Max total number of open connections to every memcached server.
#   (oslo_cache.memcache_pool backend only). (integer value)
#   Defaults to $::os_service_default
#
# [*memcache_pool_unused_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused
#   in the pool before it is closed. (oslo_cache.memcache_pool backend only)
#   (integer value)
#   Defaults to $::os_service_default
#
# [*memcache_pool_connection_get_timeout*]
#   (Optional) Number of seconds that an operation will wait to get a memcache
#   client connection. (integer value)
#   Defaults to $::os_service_default
#
# [*manage_backend_package*]
#   (Optional) Whether to install the backend package for the cache.
#   Defaults to true
#
# [*tls_enabled*]
#   (Optional) Global toggle for TLS usage when communicating with
#   the caching servers.
#   Default to $::os_service_default
#
# [*tls_cafile*]
#   (Optional) Path to a file of concatenated CA certificates in PEM
#   format necessary to establish the caching server's authenticity.
#   If tls_enabled is False, this option is ignored.
#   Default to $::os_service_default
#
# [*tls_certfile*]
#   (Optional) Path to a single file in PEM format containing the
#   client's certificate as well as any number of CA certificates
#   needed to establish the certificate's authenticity. This file
#   is only required when client side authentication is necessary.
#   If tls_enabled is False, this option is ignored.
#   Default to $::os_service_default
#
# [*tls_keyfile*]
#   (Optional) Path to a single file containing the client's private
#   key in. Otherwise the private key will be taken from the file
#   specified in tls_certfile. If tls_enabled is False, this option
#   is ignored.
#   Default to $::os_service_default
#
# [*tls_allowed_ciphers*]
#   (Optional) Set the available ciphers for sockets created with
#   the TLS context. It should be a string in the OpenSSL cipher
#   list format. If not specified, all OpenSSL enabled ciphers will
#   be available.
#   Default to $::os_service_default
#
# [*enable_retry_client*]
#   (Optional) Enable retry client mechanisms to handle failure.
#   Those mechanisms can be used to wrap all kind of pymemcache
#   clients. The wrapper allows you to define how many attempts
#   to make and how long to wait between attempts.
#   Default to $::os_service_default
#
# [*retry_attempts*]
#   (Optional) Number of times to attempt an action before failing.
#   Default to $::os_service_default
#
# [*retry_delay*]
#   (Optional) Number of seconds to sleep between each attempt.
#   Default to $::os_service_default
#
# [*hashclient_retry_attempts*]
#   (Optional) Amount of times a client should be tried
#   before it is marked dead and removed from the pool in
#   the HashClient's internal mechanisms.
#   Default to $::os_service_default
#
# [*hashclient_retry_delay*]
#   (Optional) Time in seconds that should pass between
#   retry attempts in the HashClient's internal mechanisms.
#   Default to $::os_service_default
#
# [*dead_timeout*]
#   (Optional) Time in seconds before attempting to add a node
#   back in the pool in the HashClient's internal mechanisms.
#   Default to $::os_service_default
#
class ceilometer::cache (
  $config_prefix                        = $::os_service_default,
  $expiration_time                      = $::os_service_default,
  $backend                              = $::os_service_default,
  $backend_argument                     = $::os_service_default,
  $proxies                              = $::os_service_default,
  $enabled                              = $::os_service_default,
  $debug_cache_backend                  = $::os_service_default,
  $memcache_servers                     = $::os_service_default,
  $memcache_dead_retry                  = $::os_service_default,
  $memcache_socket_timeout              = $::os_service_default,
  $enable_socket_keepalive              = $::os_service_default,
  $socket_keepalive_idle                = $::os_service_default,
  $socket_keepalive_interval            = $::os_service_default,
  $socket_keepalive_count               = $::os_service_default,
  $memcache_pool_maxsize                = $::os_service_default,
  $memcache_pool_unused_timeout         = $::os_service_default,
  $memcache_pool_connection_get_timeout = $::os_service_default,
  $manage_backend_package               = true,
  $tls_enabled                          = $::os_service_default,
  $tls_cafile                           = $::os_service_default,
  $tls_certfile                         = $::os_service_default,
  $tls_keyfile                          = $::os_service_default,
  $tls_allowed_ciphers                  = $::os_service_default,
  $enable_retry_client                  = $::os_service_default,
  $retry_attempts                       = $::os_service_default,
  $retry_delay                          = $::os_service_default,
  $hashclient_retry_attempts            = $::os_service_default,
  $hashclient_retry_delay               = $::os_service_default,
  $dead_timeout                         = $::os_service_default,
) {

  include ceilometer::deps

  $backend_real                   = pick($::ceilometer::cache_backend, $backend)
  $memcache_servers_real          = pick($::ceilometer::memcache_servers, $memcache_servers)
  $enable_socket_keepalive_real   = pick($::ceilometer::cache_enable_socket_keepalive, $enable_socket_keepalive)
  $socket_keepalive_idle_real     = pick($::ceilometer::cache_socket_keepalive_idle, $socket_keepalive_idle)
  $socket_keepalive_interval_real = pick($::ceilometer::cache_socket_keepalive_interval, $socket_keepalive_interval)
  $socket_keepalive_count_real    = pick($::ceilometer::cache_socket_keepalive_count, $socket_keepalive_count)
  $manage_backend_package_real    = pick($::ceilometer::manage_backend_package, $manage_backend_package)
  $tls_enabled_real               = pick($::ceilometer::cache_tls_enabled, $tls_enabled)
  $tls_cafile_real                = pick($::ceilometer::cache_tls_cafile, $tls_cafile)
  $tls_certfile_real              = pick($::ceilometer::cache_tls_certfile, $tls_certfile)
  $tls_keyfile_real               = pick($::ceilometer::cache_tls_keyfile, $tls_keyfile)
  $tls_allowed_ciphers_real       = pick($::ceilometer::cache_tls_allowed_ciphers, $tls_allowed_ciphers)
  $enable_retry_client_real       = pick($::ceilometer::cache_enable_retry_client, $enable_retry_client)
  $retry_attempts_real            = pick($::ceilometer::cache_retry_attempts, $retry_attempts)
  $retry_delay_real               = pick($::ceilometer::cache_retry_delay, $retry_delay)
  $hashclient_retry_attempts_real = pick($::ceilometer::cache_hashclient_retry_attempts, $hashclient_retry_attempts)
  $hashclient_retry_delay_real    = pick($::ceilometer::cache_hashclient_retry_delay, $hashclient_retry_delay)
  $dead_timeout_real              = pick($::ceilometer::cache_dead_timeout, $dead_timeout)

  oslo::cache { 'ceilometer_config':
    config_prefix                        => $config_prefix,
    expiration_time                      => $expiration_time,
    backend                              => $backend_real,
    backend_argument                     => $backend_argument,
    proxies                              => $proxies,
    enabled                              => $enabled,
    debug_cache_backend                  => $debug_cache_backend,
    memcache_servers                     => $memcache_servers_real,
    memcache_dead_retry                  => $memcache_dead_retry,
    memcache_socket_timeout              => $memcache_socket_timeout,
    enable_socket_keepalive              => $enable_socket_keepalive_real,
    socket_keepalive_idle                => $socket_keepalive_idle_real,
    socket_keepalive_interval            => $socket_keepalive_interval_real,
    socket_keepalive_count               => $socket_keepalive_count_real,
    memcache_pool_maxsize                => $memcache_pool_maxsize,
    memcache_pool_unused_timeout         => $memcache_pool_unused_timeout,
    memcache_pool_connection_get_timeout => $memcache_pool_connection_get_timeout,
    manage_backend_package               => $manage_backend_package_real,
    tls_enabled                          => $tls_enabled_real,
    tls_cafile                           => $tls_cafile_real,
    tls_certfile                         => $tls_certfile_real,
    tls_keyfile                          => $tls_keyfile_real,
    tls_allowed_ciphers                  => $tls_allowed_ciphers_real,
    enable_retry_client                  => $enable_retry_client_real,
    retry_attempts                       => $retry_attempts_real,
    retry_delay                          => $retry_delay_real,
    hashclient_retry_attempts            => $hashclient_retry_attempts_real,
    hashclient_retry_delay               => $hashclient_retry_delay_real,
    dead_timeout                         => $dead_timeout_real,
  }
}
