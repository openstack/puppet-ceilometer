require 'spec_helper'

describe 'ceilometer::db::mysql' do

  let :pre_condition do
    'include mysql::server'
  end

  let :params do
    { :password     => 'ceilometerpass',
      :dbname       => 'ceilometer',
      :user         => 'ceilometer',
      :host         => 'localhost',
      :charset      => 'utf8',
      :collate      => 'utf8_general_ci',
    }
  end

  shared_examples_for 'ceilometer mysql database' do
    it { is_expected.to contain_class('ceilometer::deps') }

    context 'when omitting the required parameter password' do
      before { params.delete(:password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it 'creates a mysql database' do
      is_expected.to contain_openstacklib__db__mysql( params[:dbname] ).with(
        :user     => params[:user],
        :password => params[:password],
        :host     => params[:host],
        :charset  => params[:charset]
      )
    end

    describe "overriding allowed_hosts param to array" do
      let :params do
        {
          :password       => 'ceilometerpass',
          :allowed_hosts  => ['localhost','%']
        }
      end

    end

    describe "overriding allowed_hosts param to string" do
      let :params do
        {
          :password       => 'ceilometerpass2',
          :allowed_hosts  => '192.168.1.1'
        }
      end

    end

    describe "overriding allowed_hosts param equals to host param " do
      let :params do
        {
          :password       => 'ceilometerpass2',
          :allowed_hosts  => 'localhost'
        }
      end

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'ceilometer mysql database'
    end
  end

end
