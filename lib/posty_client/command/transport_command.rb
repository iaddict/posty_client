module PostyClient
  module Command
    class TransportCommand < Thor
      include ServerOptionConcern

      desc "list", "list all transports"
      def list
        transports = PostyClient::Resources::Transport.all.map {|d| [d.name]}
        print_table(transports)
      end

      desc "add [DOMAIN] [DESTINATION]", "add a transport"
      def add(name, destination)
        transport = PostyClient::Resources::Transport.new(name)
        transport.attributes['destination'] = destination
        
        unless transport.save
          say transport.errors.inspect, :red
          exit 1
        end
      end

      desc "rename [DOMAIN] [NEW_DOMAIN]", "rename specified transport"
      def rename(name, new_name)
        transport = PostyClient::Resources::Transport.new(name)
        transport.attributes['name'] = new_name
        
        unless transport.save
          say transport.errors.inspect, :red
          exit 1
        end
      end

      desc "delete [DOMAIN]", "delete a specified transport"
      def delete(name)
        if yes?("Delete #{name}?")
          transport = PostyClient::Resources::Transport.new(name)
          unless transport.delete
            say transport.errors.inspect, :red
            exit 1
          end
        end
      end
    end
  end
end