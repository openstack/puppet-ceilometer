#
# Sets up ceilometer users, service and endpoint
#
# == Parameters:
#
#  $password: ceilometer user's password
#    Mandatory
#  $email: ceilometer user's email
#    Optional.
#  $auth_name: username
#    Optional. Defaults to 'ceilometer'.
#  $service_type: type of service to create.
#    Optional. Defaults to 'metering'.
#  $public_address: Public address for endpoint.
#    Optional. Defaults to 127.0.0.1.
#  $admin_address: Admin address for endpoint.
#    Optional. Defaults to 127.0.0.1.
#  $internal_address: Internal address for endpoint.
#    Optional. Defaults to 127.0.0.1.
#  $port: Port for endpoint. Needs to match ceilometer api service port.
#    Optional. Defaults to 8777.
#  $region: Region where endpoint is set.
#    Optional. Defaults to 'RegionOne'.
#  $tenant: Service tenant name.
#    Optional. Defaults to 'services'.
#  $public_protocol: http/https.
#    Optional. Defaults to 'http'.
#  $configure_endpoint: should the endpoint be created in keystone ?
#    Optional. Defaults to true
#
class ceilometer::keystone::auth(
  $password           = undef,
  $email              = 'ceilometer@localhost',
  $auth_name          = 'ceilometer',
  $service_type       = 'metering',
  $public_address     = '127.0.0.1',
  $admin_address      = '127.0.0.1',
  $internal_address   = '127.0.0.1',
  $port               = '8777',
  $region             = 'RegionOne',
  $tenant             = 'services',
  $public_protocol    = 'http',
  $admin_protocol     = 'http',
  $internal_protocol  = 'http',
  $configure_endpoint = true
) {

  #FIXME: ensure $password is not empty

  Keystone_user_role["${auth_name}@${tenant}"] ~>
    Service <| name == 'ceilometer' |>

  keystone_user { $auth_name:
    ensure   => present,
    password => $password,
    email    => $email,
    tenant   => $tenant,
  }
  if !defined(Keystone_role['ResellerAdmin']) {
    keystone_role { 'ResellerAdmin':
      ensure => present,
    }
  }
  keystone_user_role { "${auth_name}@${tenant}":
    ensure  => present,
    roles   => ['admin', 'ResellerAdmin'],
    require => Keystone_role['ResellerAdmin'],
  }
  keystone_service { $auth_name:
    ensure      => present,
    type        => $service_type,
    description => 'Openstack Metering Service',
  }
  if $configure_endpoint {
    keystone_endpoint { "${region}/${auth_name}":
      ensure       => present,
      public_url   => "${public_protocol}://${public_address}:${port}",
      admin_url    => "${admin_protocol}://${admin_address}:${port}",
      internal_url => "${internal_protocol}://${internal_address}:${port}",
    }
  }
}

