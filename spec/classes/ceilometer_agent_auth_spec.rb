require 'spec_helper'

describe 'ceilometer::agent::auth' do

  let :pre_condition do
    "class { 'ceilometer': telemetry_secret => 's3cr3t' }"
  end

  let :params do
    { :auth_url         => 'http://localhost:5000',
      :auth_region      => '<SERVICE DEFAULT>',
      :auth_user        => 'ceilometer',
      :auth_password    => 'password',
      :auth_tenant_name => 'services',
    }
  end

  shared_examples_for 'ceilometer-agent-auth' do

    it 'configures authentication' do
      is_expected.to contain_ceilometer_config('service_credentials/auth_url').with_value('http://localhost:5000')
      is_expected.to contain_ceilometer_config('service_credentials/region_name').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_ceilometer_config('service_credentials/username').with_value('ceilometer')
      is_expected.to contain_ceilometer_config('service_credentials/password').with_value('password')
      is_expected.to contain_ceilometer_config('service_credentials/password').with_value(params[:auth_password]).with_secret(true)
      is_expected.to contain_ceilometer_config('service_credentials/project_name').with_value('services')
      is_expected.to contain_ceilometer_config('service_credentials/ca_file').with(:ensure => 'absent')
      is_expected.to contain_ceilometer_config('service_credentials/user_domain_name').with_value('Default')
      is_expected.to contain_ceilometer_config('service_credentials/project_domain_name').with_value('Default')
      is_expected.to contain_ceilometer_config('service_credentials/auth_type').with_value('password')
    end

    context 'when overriding parameters' do
      before do
        params.merge!(
          :auth_cacert               => '/tmp/dummy.pem',
          :auth_endpoint_type        => 'internalURL',
          :auth_type                 => 'password',
          :auth_user_domain_name     => 'MyDomain',
          :auth_project_domain_name  => 'MyProjDomain',
        )
      end
      it { is_expected.to contain_ceilometer_config('service_credentials/ca_file').with_value(params[:auth_cacert]) }
      it { is_expected.to contain_ceilometer_config('service_credentials/interface').with_value(params[:auth_endpoint_type]) }
      it { is_expected.to contain_ceilometer_config('service_credentials/user_domain_name').with_value(params[:auth_user_domain_name]) }
      it { is_expected.to contain_ceilometer_config('service_credentials/project_domain_name').with_value(params[:auth_project_domain_name]) }
      it { is_expected.to contain_ceilometer_config('service_credentials/auth_type').with_value(params[:auth_type]) }
    end

  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'Debian' })
    end

    it_configures 'ceilometer-agent-auth'
  end

  context 'on RedHat platforms' do
    let :facts do
      @default_facts.merge({ :osfamily => 'RedHat' })
    end

    it_configures 'ceilometer-agent-auth'
  end

end
