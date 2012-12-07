class ceilometer::notify::rabbitmq(
  $rabbit_password,
  $rabbit_userid   = 'guest',
  $rabbit_host     = 'localhost'
) inherits ceilometer::api {

  ceilometer_api_config {
    'DEFAULT/notifier_strategy': value => 'rabbit';
    'DEFAULT/rabbit_host':       value => $rabbit_host;
    'DEFAULT/rabbit_password':   value => $rabbit_password;
    'DEFAULT/rabbit_userid':     value => $rabbit_userid;
  }
}

