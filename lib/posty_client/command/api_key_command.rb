module PostyClient
  module Command
    class ApiKeyCommand < Thor
      include PostyClient::Resources
      
      desc "list", "list all api keys"
      def list
        api_keys = PostyClient::Resources::ApiKey.all.map {|d| [d.attributes["access_token"], d.attributes["expires_at"]]}
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
        api_key.expire
      end

      desc "delete [token]", "delete a specified token"
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