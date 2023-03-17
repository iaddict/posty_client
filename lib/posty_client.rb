require "logger"
require "active_support/all"
require "faraday"

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
    ENV['POSTY_ENV'] || 'development'
  end

  def self.root
    File.expand_path(File.dirname(__FILE__)+'/../')
  end

  # @return [Logger]
  mattr_accessor :logger do
    Logger.new(STDOUT).tap do |logger|
      logger.level = if ENV['DEBUG']
                       Logger::DEBUG
                     else
                       Logger::INFO
                     end
    end
  end
end

require "posty_client/settings"

require "posty_client/resources/base"
require "posty_client/resources/domain"
require "posty_client/resources/user"
require "posty_client/resources/domain_alias"
require "posty_client/resources/domain_forwarder"
require "posty_client/resources/user_alias"
require "posty_client/resources/transport"
require "posty_client/resources/api_key"
require "posty_client/resources/dkim_record"
require "posty_client/resources/summary"