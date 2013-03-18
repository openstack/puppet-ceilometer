#
# Sets up ceilometer users, service and endpoint
#
# == Parameters:
#
#  $auth_name :: identifier used for all keystone objects related to ceilometer.
#    Optional. Defaults to ceilometer.
#  $password :: password for ceilometer user. Optional. Defaults to glance_password.
#  $service_type :: type of service to create. Optional. Defaults to image.
#  $public_address :: Public address for endpoint. Optional. Defaults to 127.0.0.1.
#  $admin_address :: Admin address for endpoint. Optional. Defaults to 127.0.0.1.
#  $inernal_address :: Internal address for endpoint. Optional. Defaults to 127.0.0.1.
#  $port :: Port for endpoint. Needs to match ceilometer api service port. Optional.
#    Defaults to 8777.
#  $region :: Region where endpoint is set.
#
class ceilometer::keystone::auth(
  $password,
  $email              = 'ceilometer@localhost',
  $auth_name          = 'ceilometer',
  $configure_endpoint = true,
  $service_type       = 'metering',
  $public_address     = '127.0.0.1',
  $admin_address      = '127.0.0.1',
  $internal_address   = '127.0.0.1',
  $port               = '8777',
  $region             = 'RegionOne',
  $tenant             = 'services',
  $public_protocol    = 'http'
) {

  Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'ceilometer' |>

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
      admin_url    => "http://${admin_address}:${port}",
      internal_url => "http://${internal_address}:${port}",
    }
  }
}

