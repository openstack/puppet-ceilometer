Puppet::Type.type(:ceilometer_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/ceilometer/ceilometer.conf'
  end

end
