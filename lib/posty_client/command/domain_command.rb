require_relative 'server_option_concern'

module PostyClient
  module Command
    class DomainCommand < Thor
      include ServerOptionConcern

      desc "show [DOMAIN]", "show given domain with users and aliases"
      option :complete, desc: "Load all associated entities (aliases, mailboxes, forwarders)"

      def show(domain_name)
        domain =
          PostyClient::Resources::Domain.new(domain_name, params: { complete: options[:complete] })

        if domain.new_resource?
          say "Unknown domain '#{domain.name}'", :red
          exit 1
        else
          puts domain.attributes.to_yaml
        end
      end

      desc "list", "list all domains"
      def list
        domains = PostyClient::Resources::Domain.all.map { |d| [d.name] }
        print_table(domains)
      end

      desc "add [DOMAIN]", "add a domain"
      def add(name)
        domain = PostyClient::Resources::Domain.new(name)

        unless domain.save
          say domain.errors.inspect, :red
          exit 1
        end
      end

      desc "rename [DOMAIN] [NEW_DOMAIN]", "rename specified domain"
      def rename(name, new_name)
        domain = PostyClient::Resources::Domain.new(name)
        domain.attributes['name'] = new_name
        unless domain.save
          say domain.errors.inspect, :red
          exit 1
        end
      end

      desc "delete [DOMAIN]", "delete a specified domain"
      def delete(name)
        if yes?("Delete #{name}?")
          domain = PostyClient::Resources::Domain.new(name)
          unless domain.delete
            say domain.errors.inspect, :red
            exit 1
          end
        end
      end
    end
  end
end