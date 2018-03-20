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
      class { '::openstack_integration::ceilometer':
        integration_enable => false,
      }
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
