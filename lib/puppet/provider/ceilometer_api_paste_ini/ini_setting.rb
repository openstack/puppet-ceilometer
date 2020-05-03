Puppet::Type.type(:ceilometer_api_paste_ini).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  def create
    super
    warning('ceilometer_api_paste_ini is deprecated, and will be removed in a future release')
  end

  def section
    resource[:name].split('/', 2).first
  end

  def setting
    resource[:name].split('/', 2).last
  end

  def separator
    '='
  end

  def self.file_path
    '/etc/ceilometer/api_paste.ini'
  end

  # added for backwards compatibility with older versions of inifile
  def file_path
    self.class.file_path
  end

end
