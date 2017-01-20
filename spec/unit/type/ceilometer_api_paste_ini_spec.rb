require 'spec_helper'
# this hack is required for now to ensure that the path is set up correctly
# to retrieve the parent provider
$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    'fixtures',
    'modules',
    'inifile',
    'lib')
)
require 'puppet/type/ceilometer_api_paste_ini'
describe 'Puppet::Type.type(:ceilometer_api_paste_ini)' do
  before :each do
    @ceilometer_api_paste_ini = Puppet::Type.type(:ceilometer_api_paste_ini).new(:name => 'DEFAULT/foo', :value => 'bar')
  end
  it 'should accept a valid value' do
    @ceilometer_api_paste_ini[:value] = 'bar'
    expect(@ceilometer_api_paste_ini[:value]).to eq('bar')
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    package = Puppet::Type.type(:package).new(:name => 'ceilometer')
    catalog.add_resource package, @ceilometer_api_paste_ini
    dependency = @ceilometer_api_paste_ini.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@ceilometer_api_paste_ini)
    expect(dependency[0].source).to eq(package)
  end

end
