require 'spec_helper'

describe 'ceilometer' do

  let :params do
    {
      :metering_secret    => 'metering-s3cr3t',
      :package_ensure     => 'present',
      :verbose            => 'False',
      :debug              => 'False',
    }
  end

  let :rabbit_params do
    {
      :rabbit_host        => '127.0.0.1',
      :rabbit_port        => 5672,
      :rabbit_userid      => 'guest',
      :rabbit_password    => '',
      :rabbit_virtual_host => '/',
    }
  end

  let :qpid_params do
    {
      :rpc_backend   => "ceilometer.openstack.common.rpc.impl_qpid",
      :qpid_hostname => 'localhost',
      :qpid_port     => 5672,
      :qpid_username => 'guest',
      :qpid_password  => 'guest',
    }
  end

  shared_examples_for 'ceilometer' do

    context 'with rabbit_host parameter' do
      before { params.merge!( rabbit_params ) }
      it_configures 'a ceilometer base installation'
      it_configures 'rabbit without HA support (with backward compatibility)'
    end

    context 'with rabbit_hosts parameter' do
      context 'with one server' do
        before { params.merge!( rabbit_params ).merge!( :rabbit_hosts => ['127.0.0.1:5672'] ) }
        it_configures 'a ceilometer base installation'
        it_configures 'rabbit without HA support (without backward compatibility)'
      end

      context 'with multiple servers' do
        before { params.merge!( rabbit_params ).merge!( :rabbit_hosts => ['rabbit1:5672', 'rabbit2:5672'] ) }
        it_configures 'a ceilometer base installation'
        it_configures 'rabbit with HA support'
      end
    end

    context 'with qpid' do
      before {params.merge!( qpid_params ) }
      it_configures 'a ceilometer base installation'
      it_configures 'qpid support'
    end

  end

  shared_examples_for 'a ceilometer base installation' do

    it { should contain_class('ceilometer::params') }

    it 'configures ceilometer group' do
      should contain_group('ceilometer').with(
        :name    => 'ceilometer',
        :require => 'Package[ceilometer-common]'
      )
    end

    it 'configures ceilometer user' do
      should contain_user('ceilometer').with(
        :name    => 'ceilometer',
        :gid     => 'ceilometer',
        :system  => true,
        :require => 'Package[ceilometer-common]'
      )
    end

    it 'configures ceilometer configuration folder' do
      should contain_file('/etc/ceilometer/').with(
        :ensure  => 'directory',
        :owner   => 'ceilometer',
        :group   => 'ceilometer',
        :mode    => '0750',
        :require => 'Package[ceilometer-common]'
      )
    end

    it 'configures ceilometer configuration file' do
      should contain_file('/etc/ceilometer/ceilometer.conf').with(
        :owner   => 'ceilometer',
        :group   => 'ceilometer',
        :mode    => '0640',
        :require => 'Package[ceilometer-common]'
      )
    end

    it 'installs ceilometer common package' do
      should contain_package('ceilometer-common').with(
        :ensure => 'present',
        :name   => platform_params[:common_package_name]
      )
    end

    it 'configures required metering_secret' do
      should contain_ceilometer_config('DEFAULT/metering_secret').with_value('metering-s3cr3t')
    end

    context 'without the required metering_secret' do
      before { params.delete(:metering_secret) }
      it { expect { should raise_error(Puppet::Error) } }
    end

    it 'configures debug and verbose' do
      should contain_ceilometer_config('DEFAULT/debug').with_value( params[:debug] )
      should contain_ceilometer_config('DEFAULT/verbose').with_value( params[:verbose] )
    end

    it 'fixes a bad value in ceilometer (glance_control_exchange)' do
      should contain_ceilometer_config('DEFAULT/glance_control_exchange').with_value('glance')
    end

    it 'adds glance-notifications topic' do
      should contain_ceilometer_config('DEFAULT/notification_topics').with_value('notifications,glance_notifications')
    end
  end

  shared_examples_for 'rabbit without HA support (with backward compatibility)' do

    it 'configures rabbit' do
      should contain_ceilometer_config('DEFAULT/rabbit_userid').with_value( params[:rabbit_userid] )
      should contain_ceilometer_config('DEFAULT/rabbit_password').with_value( params[:rabbit_password] )
      should contain_ceilometer_config('DEFAULT/rabbit_virtual_host').with_value( params[:rabbit_virtual_host] )
    end

    it { should contain_ceilometer_config('DEFAULT/rabbit_host').with_value( params[:rabbit_host] ) }
    it { should contain_ceilometer_config('DEFAULT/rabbit_port').with_value( params[:rabbit_port] ) }
    it { should contain_ceilometer_config('DEFAULT/rabbit_hosts').with_value( "#{params[:rabbit_host]}:#{params[:rabbit_port]}" ) }
    it { should contain_ceilometer_config('DEFAULT/rabbit_ha_queues').with_value('false') }
  end

  shared_examples_for 'rabbit without HA support (without backward compatibility)' do

    it 'configures rabbit' do
      should contain_ceilometer_config('DEFAULT/rabbit_userid').with_value( params[:rabbit_userid] )
      should contain_ceilometer_config('DEFAULT/rabbit_password').with_value( params[:rabbit_password] )
      should contain_ceilometer_config('DEFAULT/rabbit_virtual_host').with_value( params[:rabbit_virtual_host] )
    end

    it { should contain_ceilometer_config('DEFAULT/rabbit_host').with_ensure('absent') }
    it { should contain_ceilometer_config('DEFAULT/rabbit_port').with_ensure('absent') }
    it { should contain_ceilometer_config('DEFAULT/rabbit_hosts').with_value( params[:rabbit_hosts].join(',') ) }
    it { should contain_ceilometer_config('DEFAULT/rabbit_ha_queues').with_value('false') }
  end

  shared_examples_for 'rabbit with HA support' do

    it 'configures rabbit' do
      should contain_ceilometer_config('DEFAULT/rabbit_userid').with_value( params[:rabbit_userid] )
      should contain_ceilometer_config('DEFAULT/rabbit_password').with_value( params[:rabbit_password] )
      should contain_ceilometer_config('DEFAULT/rabbit_virtual_host').with_value( params[:rabbit_virtual_host] )
    end

    it { should contain_ceilometer_config('DEFAULT/rabbit_host').with_ensure('absent') }
    it { should contain_ceilometer_config('DEFAULT/rabbit_port').with_ensure('absent') }
    it { should contain_ceilometer_config('DEFAULT/rabbit_hosts').with_value( params[:rabbit_hosts].join(',') ) }
    it { should contain_ceilometer_config('DEFAULT/rabbit_ha_queues').with_value('true') }
  end

  shared_examples_for 'qpid support' do
    context("with default parameters") do
      it { should contain_ceilometer_config('DEFAULT/qpid_reconnect').with_value(true) }
      it { should contain_ceilometer_config('DEFAULT/qpid_reconnect_timeout').with_value('0') }
      it { should contain_ceilometer_config('DEFAULT/qpid_reconnect_limit').with_value('0') }
      it { should contain_ceilometer_config('DEFAULT/qpid_reconnect_interval_min').with_value('0') }
      it { should contain_ceilometer_config('DEFAULT/qpid_reconnect_interval_max').with_value('0') }
      it { should contain_ceilometer_config('DEFAULT/qpid_reconnect_interval').with_value('0') }
      it { should contain_ceilometer_config('DEFAULT/qpid_heartbeat').with_value('60') }
      it { should contain_ceilometer_config('DEFAULT/qpid_protocol').with_value('tcp') }
      it { should contain_ceilometer_config('DEFAULT/qpid_tcp_nodelay').with_value(true) }
      end

    context("with mandatory parameters set") do
      it { should contain_ceilometer_config('DEFAULT/rpc_backend').with_value('ceilometer.openstack.common.rpc.impl_qpid') }
      it { should contain_ceilometer_config('DEFAULT/qpid_hostname').with_value( params[:qpid_hostname] ) }
      it { should contain_ceilometer_config('DEFAULT/qpid_port').with_value( params[:qpid_port] ) }
      it { should contain_ceilometer_config('DEFAULT/qpid_username').with_value( params[:qpid_username]) }
      it { should contain_ceilometer_config('DEFAULT/qpid_password').with_value(params[:qpid_password]) }
    end

    context("failing if the rpc_backend is not present") do
      before { params.delete( :rpc_backend) }
      it { expect { should raise_error(Puppet::Error) } }
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :common_package_name => 'ceilometer-common' }
    end

    it_configures 'ceilometer'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :common_package_name => 'openstack-ceilometer-common' }
    end

    it_configures 'ceilometer'
  end
end
