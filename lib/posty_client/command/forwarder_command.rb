require 'posty_client/command/finder_concerns'

module PostyClient
  module Command
    class ForwarderCommand < Thor
      include PostyClient::Resources
      include PostyClient::Command::FinderConcerns
      include PostyClient::Command::ServerOptionConcern

      no_commands do
        # @param [String] name like an email
        def find_or_initialize_forwarder(name)
          forwarder_name, domain_name = user_and_domain_from_email(name)
          domain = find_domain_by_name(domain_name)

          DomainForwarder.new(domain, forwarder_name)
        end
      end

      desc "list [DOMAIN]", "list all forwarders of given domain"
      def list(domain)
        domain = find_domain_by_name(domain)
        forwarders = domain.forwarders
        puts forwarders.map(&:name)
      end

      desc "show [USER]@[DOMAIN]", "show given forwarder"
      def show(name)
        forwarder = find_or_initialize_forwarder(name)
        if forwarder.new_resource?
          say("Unknown forwarder #{name}", :red)
          exit 1
        end

        puts forwarder.attributes.to_yaml
      end

      desc "add [USER]@[DOMAIN] [destination,destination,...]", "add a forwarder"
      def add(name, destination)
        forwarder = find_or_initialize_forwarder(name)
        unless forwarder.new_resource?
          say("Forwarder already exists", :red)
          exit 1
        end

        forwarder.attributes['destination'] = destination
        unless forwarder.save
          say("#{name} save failed: #{forwarder.errors}", :red)
          exit 1
        end
      end

      desc "update [USER]@[DOMAIN] [destination,destination,...]", "update the specified forwarder (all destination have to be given!)"
      def update(name, destination)
        forwarder = find_or_initialize_forwarder(name)
        if forwarder.new_resource?
          say("Forwarder does not exist", :red)
          exit 1
        end

        forwarder.attributes['destination'] = destination
        unless forwarder.save
          say("#{name} save failed: #{forwarder.errors}", :red)
          exit 1
        end
      end

      desc "delete [USER]@[DOMAIN]", "delete a specified forwarder from the given domain"
      def delete(name)
        forwarder = find_or_initialize_forwarder(name)
        if forwarder.new_resource?
          say("#{name} unknown", :red)
          exit 1
        end

        unless forwarder.delete
          say("#{name} delete failed: #{user.errors}", :red)
          exit 1
        end
      end
    end
  end
end
