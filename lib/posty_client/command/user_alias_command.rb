require 'posty_client/command/finder_concerns'

module PostyClient
  module Command
    class UserAliasCommand < Thor
      include PostyClient::Resources
      include PostyClient::Command::FinderConcerns

      desc "list [USER]@[DOMAIN]", "list all user aliases of given user"
      def list(name)
        user = find_user_by_email(name)
        users = user.aliases
        puts users.map(&:name)
      end

      desc "add [USER]@[DOMAIN] [USER_ALIAS]", "add a user alias"
      def add(email, alias_name)
        user = find_user_by_email(email)

        ali = UserAlias.new(user, alias_name)

        unless ali.save
          say("#{alias_name} save failed: #{ali.errors}", :red)
          exit 1
        end
      end

      desc "delete [ALIAS]@[DOMAIN] [USER_ALIAS]", "delete the specified user alias"
      def delete(email, alias_name)
        ali = find_user_alias_by_email_and_name(email, alias_name)
        
        if ali.new_resource?
          say("#{alias_name} unknown", :red)
          exit 1
        end

        unless ali.delete
          say("#{alias_name} delete failed: #{ali.errors}", :red)
          exit 1
        end
      end
    end
  end
end
