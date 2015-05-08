module PostyClient
  module Command
    class DomainCommand < Thor
      desc "list", "list all domains"
      def list
        domains = PostyClient::Resources::Domain.all.map {|d| [d.name]}
        print_table(domains)
      end

      desc "add [DOMAIN] [QUOTA/MB]", "add a domain"
      def add(name, quota)
        domain = PostyClient::Resources::Domain.new(name)
        
        if quota.present?
          user.quota = quota
        end
        
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