require 'spec_helper_acceptance'

describe 'ceilometer with mysql' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

      # TODO(aschultz): remove after fix for LP#1621384 hits RDO
      include ::gnocchi::client
      Package['python-gnocchiclient'] -> Exec[ceilometer-upgrade]

      rabbitmq_user { 'ceilometer':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'ceilometer@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Ceilometer resources
      class { '::ceilometer':
        debug                 => true,
        telemetry_secret      => 'secrete',
        default_transport_url => 'rabbit://ceilometer:an_even_bigger_secret@127.0.0.1:5672',
      }
      class { '::ceilometer::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::ceilometer::db::mysql':
        password => 'a_big_secret',
      }
      class { '::ceilometer::db':
        database_connection => 'mysql+pymysql://ceilometer:a_big_secret@127.0.0.1/ceilometer?charset=utf8',
	sync_db             => false,
      }
      # NOTE(tobasco): When running the beaker tests we need to exclude the
      # gnocchi resource types since the acceptance test does not setup gnocchi itself.
      class { '::ceilometer::db::sync':
        extra_params => '--skip-gnocchi-resource-types',
      }
      class { '::ceilometer::expirer': }
      class { '::ceilometer::agent::central': }
      class { '::ceilometer::agent::notification': }
      class { '::ceilometer::keystone::authtoken':
        password => 'a_big_secret',
      }
      class { '::ceilometer::dispatcher::gnocchi': }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe cron do
      it { is_expected.to have_entry('1 0 * * * ceilometer-expirer').with_user('ceilometer') }
    end

  end
end
