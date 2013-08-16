require "logger"
require "active_support/all"
require "readwritesettings"
require "rest_client"

$: << File.expand_path(File.dirname(__FILE__)+'/../lib')

require "posty_client/version"

module PostyClient
  def self.settings_file
    default_file = File.expand_path('~/.posty_client.yml')

    @settings_file ||= if File.exists?(default_file)
      default_file
    else
      # this is set to make the cli not bark on missing settings
      PostyClient.root + '/config/posty_client.yml.dist'
    end
  end

  def self.settings_file=(file_path)
    @settings_file = file_path
    Settings.source(@settings_file)
  end

  def self.env
    'development' || ENV['POSTY_ENV']
  end

  def self.root
    File.expand_path(File.dirname(__FILE__)+'/../')
  end

  mattr_accessor :logger
  self.logger = Logger.new(STDOUT)
end

RestClient.add_before_execution_proc do |req, params|
  req['auth_token'] = PostyClient::Settings.access_token
end


require "posty_client/settings"

require "posty_client/resources/base"
require "posty_client/resources/domain"
require "posty_client/resources/user"
require "posty_client/resources/domain_alias"
require "posty_client/resources/user_alias"
require "posty_client/resources/transport"
require "posty_client/resources/api_key"