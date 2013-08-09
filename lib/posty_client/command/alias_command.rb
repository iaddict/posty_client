require 'posty_client/command/finder_concerns'

module PostyClient
  module Command
    class AliasCommand < Thor
      include PostyClient::Resources
      include PostyClient::Command::FinderConcerns

      desc "list [DOMAIN]", "list all users of given domain"
      def list(domain)
        domain = Domain.new(domain)
        users = domain.aliases
        print_list(users.map(&:name))
      end

      desc "add [USER]@[DOMAIN] [ALIAS]", "add an alias"
      def add(name, alias_name)
        user = find_user_by_email(name)

        ali = Alias.new(user.domain, alias_name)
        ali.attributes['destination'] = user.name

        unless ali.save
          say("#{alias_name} save failed: #{ali.errors}", :red)
          exit 1
        end
      end

      desc "delete [ALIAS]@[DOMAIN]", "delete the specified alias"
      def delete(name)
        ali = find_alias_by_email(name)
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
