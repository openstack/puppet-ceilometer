require 'spec_helper_acceptance'

describe 'basic ceilometer_config resource' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      File <||> -> Ceilometer_config <||>
      File <||> -> Ceilometer_rootwrap_config <||>

      file { '/etc/ceilometer' :
        ensure => directory,
      }
      file { '/etc/ceilometer/ceilometer.conf' :
        ensure => file,
      }
      file { '/etc/ceilometer/rootwrap.conf' :
        ensure => file,
      }

      ceilometer_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      ceilometer_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      ceilometer_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      ceilometer_config { 'DEFAULT/thisshouldexist3' :
        value => ['foo', 'bar'],
      }

      ceilometer_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }

      ceilometer_rootwrap_config { 'DEFAULT/thisshouldexist' :
        value => 'foo',
      }

      ceilometer_rootwrap_config { 'DEFAULT/thisshouldnotexist' :
        value => '<SERVICE DEFAULT>',
      }

      ceilometer_rootwrap_config { 'DEFAULT/thisshouldexist2' :
        value             => '<SERVICE DEFAULT>',
        ensure_absent_val => 'toto',
      }

      ceilometer_rootwrap_config { 'DEFAULT/thisshouldnotexist2' :
        value             => 'toto',
        ensure_absent_val => 'toto',
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/etc/ceilometer/ceilometer.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }
      it { is_expected.to contain('thisshouldexist3=foo') }
      it { is_expected.to contain('thisshouldexist3=bar') }

      describe '#content' do
        subject { super().content }
        it { is_expected.to_not match /thisshouldnotexist/ }
      end
    end

    describe file('/etc/ceilometer/rootwrap.conf') do
      it { is_expected.to exist }
      it { is_expected.to contain('thisshouldexist=foo') }
      it { is_expected.to contain('thisshouldexist2=<SERVICE DEFAULT>') }

      describe '#content' do
        subject { super().content }
        it { is_expected.to_not match /thisshouldnotexist/ }
      end
    end
  end
end
