# class: ceilometer::keystone::authtoken
#
# DEPRECATED !
# Configure the keystone_authtoken section in the configuration file
#
# === Parameters
#
# [*username*]
#   (Optional) The name of the service user
#   Defaults to undef.
#
# [*password*]
#   (Optional) Password to create for the service user
#   Defaults to undef.
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to undef.
#
# [*project_name*]
#   (Optional) Service project name
#   Defaults to undef.
#
# [*user_domain_name*]
#   (Optional) Name of domain for $username
#   Defaults to undef
#
# [*project_domain_name*]
#   (Optional) Name of domain for $project_name
#   Defaults to undef
#
# [*insecure*]
#   (Optional) If true, explicitly allow TLS without checking server cert
#   against any certificate authorities.  WARNING: not recommended.  Use with
#   caution.
#   Defaults to undef
#
# [*auth_section*]
#   (Optional) Config Section from which to load plugin specific options
#   Defaults to undef.
#
# [*auth_type*]
#   (Optional) Authentication type to load
#   Defaults to undef
#
# [*www_authenticate_uri*]
#   (Optional) Complete public Identity API endpoint.
#   Defaults to undef
#
# [*auth_version*]
#   (Optional) API version of the admin Identity API endpoint.
#   Defaults to undef.
#
# [*cache*]
#   (Optional) Env key for the swift cache.
#   Defaults to undef.
#
# [*cafile*]
#   (Optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to undef.
#
# [*certfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to undef.
#
# [*delay_auth_decision*]
#   (Optional) Do not handle authorization requests within the middleware, but
#   delegate the authorization decision to downstream WSGI components. Boolean
#   value
#   Defaults to undef.
#
# [*enforce_token_bind*]
#   (Optional) Used to control the use and type of token binding. Can be set
#   to: "disabled" to not check token binding. "permissive" (default) to
#   validate binding information if the bind type is of a form known to the
#   server and ignore it if not. "strict" like "permissive" but if the bind
#   type is unknown the token will be rejected. "required" any form of token
#   binding is needed to be allowed. Finally the name of a binding method that
#   must be present in tokens. String value.
#   Defaults to undef.
#
# [*http_connect_timeout*]
#   (Optional) Request timeout value for communicating with Identity API
#   server.
#   Defaults to undef.
#
# [*http_request_max_retries*]
#   (Optional) How many times are we trying to reconnect when communicating
#   with Identity API Server. Integer value
#   Defaults to undef.
#
# [*include_service_catalog*]
#   (Optional) Indicate whether to set the X-Service-Catalog header. If False,
#   middleware will not ask for service catalog on token validation and will
#   not set the X-Service-Catalog header. Boolean value.
#   Defaults to undef.
#
# [*keyfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to undef.
#
# [*memcache_pool_conn_get_timeout*]
#   (Optional) Number of seconds that an operation will wait to get a memcached
#   client connection from the pool. Integer value
#   Defaults to undef.
#
# [*memcache_pool_dead_retry*]
#   (Optional) Number of seconds memcached server is considered dead before it
#   is tried again. Integer value
#   Defaults to undef.
#
# [*memcache_pool_maxsize*]
#   (Optional) Maximum total number of open connections to every memcached
#   server. Integer value
#   Defaults to undef.
#
# [*memcache_pool_socket_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused in
#   the pool before it is closed. Integer value
#   Defaults to undef.
#
# [*memcache_pool_unused_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused in
#   the pool before it is closed. Integer value
#   Defaults to undef.
#
# [*memcache_secret_key*]
#   (Optional, mandatory if memcache_security_strategy is defined) This string
#   is used for key derivation.
#   Defaults to undef.
#
# [*memcache_security_strategy*]
#   (Optional) If defined, indicate whether token data should be authenticated
#   or authenticated and encrypted. If MAC, token data is authenticated (with
#   HMAC) in the cache. If ENCRYPT, token data is encrypted and authenticated in the
#   cache. If the value is not one of these options or empty, auth_token will
#   raise an exception on initialization.
#   Defaults to undef.
#
# [*memcache_use_advanced_pool*]
#   (Optional)  Use the advanced (eventlet safe) memcached client pool. The
#   advanced pool will only work under python 2.x Boolean value
#   Defaults to undef.
#
# [*memcached_servers*]
#   (Optional) Optionally specify a list of memcached server(s) to use for
#   caching. If left undefined, tokens will instead be cached in-process.
#   Defaults to undef.
#
# [*manage_memcache_package*]
#  (Optional) Whether to install the python-memcache package.
#  Defaults to undef.
#
# [*region_name*]
#   (Optional) The region in which the identity server can be found.
#   Defaults to undef.
#
# [*token_cache_time*]
#   (Optional) In order to prevent excessive effort spent validating tokens,
#   the middleware caches previously-seen tokens for a configurable duration
#   (in seconds). Set to -1 to disable caching completely. Integer value
#   Defaults to undef.
#
# [*service_token_roles_required*]
#   (optional) backwards compatibility to ensure that the service tokens are
#   compared against a list of possible roles for validity
#   true/false
#   Defaults to undef.
#
class ceilometer::keystone::authtoken(
  $username                       = undef,
  $password                       = undef,
  $auth_url                       = undef,
  $project_name                   = undef,
  $user_domain_name               = undef,
  $project_domain_name            = undef,
  $insecure                       = undef,
  $auth_section                   = undef,
  $auth_type                      = undef,
  $www_authenticate_uri           = undef,
  $auth_version                   = undef,
  $cache                          = undef,
  $cafile                         = undef,
  $certfile                       = undef,
  $delay_auth_decision            = undef,
  $enforce_token_bind             = undef,
  $http_connect_timeout           = undef,
  $http_request_max_retries       = undef,
  $include_service_catalog        = undef,
  $keyfile                        = undef,
  $memcache_pool_conn_get_timeout = undef,
  $memcache_pool_dead_retry       = undef,
  $memcache_pool_maxsize          = undef,
  $memcache_pool_socket_timeout   = undef,
  $memcache_pool_unused_timeout   = undef,
  $memcache_secret_key            = undef,
  $memcache_security_strategy     = undef,
  $memcache_use_advanced_pool     = undef,
  $memcached_servers              = undef,
  $manage_memcache_package        = undef,
  $region_name                    = undef,
  $token_cache_time               = undef,
  $service_token_roles_required   = undef,
) {

  include ceilometer::deps

  warning('ceilometer::keystone::authtoken is deprecated and has not effect')
}
