require "logger"
require "active_support/all"
require "readwritesettings"

$: << File.expand_path(File.dirname(__FILE__)+'/../lib')

require "posty_client/version"

module PostyClient
  def self.settings_file
    @settings_file ||= File.expand_path('~/.posty_client.yml')
  end

  def self.settings_file=(file_path)
    @settings_file = file_path
  end

  def self.env
    'development' || ENV['POSTY_ENV']
  end

  mattr_accessor :logger
  self.logger = Logger.new(STDOUT)
end

require "posty_client/settings"

require "posty_client/resources/base"
require "posty_client/resources/domain"
require "posty_client/resources/user"
require "posty_client/resources/alias"