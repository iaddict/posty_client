require 'posty_client/command/finder_concerns'

module PostyClient
  module Command
    class DomainAliasCommand < Thor
      include PostyClient::Resources
      include PostyClient::Command::FinderConcerns
      include ServerOptionConcern

      desc "list [DOMAIN]", "list all domain aliases of given domain"
      def list(domain)
        domain = find_domain_by_name(domain)
        domain_aliases = domain.aliases
        puts domain_aliases.map(&:name)
      end

      desc "add [DOMAIN] [DOMAIN_ALIAS]", "add a domain alias"
      def add(domain_name, alias_name)
        domain = find_domain_by_name(domain_name)

        ali = DomainAlias.new(domain, alias_name)

        unless ali.save
          say("#{alias_name} save failed: #{ali.errors}", :red)
          exit 1
        end
      end

      desc "delete [DOMAIN] [DOMAIN_ALIAS]", "delete the specified domain alias"
      def delete(domain_name, name)
        ali = find_domain_alias_by_domain_and_name(domain_name, name)
        if ali.new_resource?
          say("#{name} unknown", :red)
          exit 1
        end

        unless ali.delete
          say("#{name} delete failed: #{ali.errors}", :red)
          exit 1
        end
      end
    end
  end
end
