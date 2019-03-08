require "yaml"

module PostyClient
  class Settings
    mattr_accessor :settings do
      YAML.load(ERB.new(File.read(PostyClient.settings_file)).result)
    end

    def self.servers
      settings[PostyClient.env]['servers'].keys
    end

    def self.current_server
      Thread.current["attr_#{name}_current_server"]
    end

    def self.current_server=(server)
      Thread.current["attr_#{name}_current_server"] = server
    end

    def self.current_settings
      if current_server.present?
        settings[PostyClient.env]['servers'][current_server]
      else
        settings[PostyClient.env]
      end
    end

    def self.access_token
      current_settings['access_token']
    end

    def self.api_url
      current_settings['api_url']
    end

    def self.api_version
      current_settings['api_version']
    end
  end
end
