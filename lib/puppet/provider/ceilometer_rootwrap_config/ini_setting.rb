Puppet::Type.type(:ceilometer_rootwrap_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/ceilometer/rootwrap.conf'
  end

end
