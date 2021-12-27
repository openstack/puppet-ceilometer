require 'puppet'
require 'puppet/type/ceilometer_rootwrap_config'

describe 'Puppet::Type.type(:ceilometer_rootwrap_config)' do
  before :each do
    @ceilometer_rootwrap_config = Puppet::Type.type(:ceilometer_rootwrap_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

 it 'should require a name' do
    expect {
      Puppet::Type.type(:ceilometer_rootwrap_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:ceilometer_rootwrap_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:ceilometer_rootwrap_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:ceilometer_rootwrap_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @ceilometer_rootwrap_config[:value] = 'bar'
    expect(@ceilometer_rootwrap_config[:value]).to eq('bar')
  end

  it 'should not accept a value with whitespace' do
    @ceilometer_rootwrap_config[:value] = 'b ar'
    expect(@ceilometer_rootwrap_config[:value]).to eq('b ar')
  end

  it 'should accept valid ensure values' do
    @ceilometer_rootwrap_config[:ensure] = :present
    expect(@ceilometer_rootwrap_config[:ensure]).to eq(:present)
    @ceilometer_rootwrap_config[:ensure] = :absent
    expect(@ceilometer_rootwrap_config[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @ceilometer_rootwrap_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    anchor = Puppet::Type.type(:anchor).new(:name => 'ceilometer::install::end')
    catalog.add_resource anchor, @ceilometer_rootwrap_config
    dependency = @ceilometer_rootwrap_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@ceilometer_rootwrap_config)
    expect(dependency[0].source).to eq(anchor)
  end

end
