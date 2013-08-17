module PostyClient
  module Command
    class ApiKeyCommand < Thor
      include PostyClient::Resources
      
      desc "list", "list all api keys"
      def list
        api_keys = PostyClient::Resources::ApiKey.all.map {|d| [d.attributes["access_token"], set_color(d.attributes["expires_at"], d.expired? ? :red : :green), set_color(d.attributes["active"], d.active? ? :green : :red)]}
        api_keys.unshift(["API Key", "Expires at", "Active"])
        print_table(api_keys)
      end

      desc "add", "add a api key"
      def add
        api_key = PostyClient::Resources::ApiKey.new("")
        api_key.create
      end

      desc "expire [TOKEN]", "expires the given token"
      def expire(token)
        api_key = PostyClient::Resources::ApiKey.new(token)
        api_key.attributes['expires_at'] = DateTime.now
        unless api_key.save
          say api_key.errors.inspect, :red
          exit 1
        end
      end
      
      desc "disable [TOKEN]", "disables the given token"
      def disable(token)
        api_key = PostyClient::Resources::ApiKey.new(token)
        api_key.attributes['active'] = false
        unless api_key.save
          say api_key.errors.inspect, :red
          exit 1
        end
      end

      desc "enable [TOKEN]", "enables the given token"
      def enable(token)
        api_key = PostyClient::Resources::ApiKey.new(token)
        api_key.attributes['active'] = true
        unless api_key.save
          say api_key.errors.inspect, :red
          exit 1
        end
      end

      desc "delete [TOKEN]", "delete a specified token"
      def delete(token)
        if yes?("Delete #{name}?")
          transport = PostyClient::Resources::Transport.new(token)
          unless transport.delete
            say transport.errors.inspect, :red
            exit 1
          end
        end
      end
    end
  end
end