require 'posty_client/command/finder_concerns'

module PostyClient
  module Command
    class UserCommand < Thor
      include PostyClient::Resources
      include PostyClient::Command::FinderConcerns

      desc "list [DOMAIN]", "list all users of given domain"
      def list(domain)
        domain = Domain.new(domain)
        users = domain.users
        puts users.map(&:name)
      end

      desc "add [USER]@[DOMAIN] [QUOTA/MB]", "add a user"
      def add(name, quota)
        user = find_user_by_email(name)
        
        if quota.present?
          user.quota = quota
        end

        password = ask('Password?')
        unless password.blank?
          user.attributes['password'] = password
        end

        unless user.save
          say("#{name} save failed: #{user.errors}", :red)
          exit 1
        end
      end

      desc "rename [USER]@[DOMAIN] [NEW_USER]", "rename a specified user"
      def rename(name, new_name)
        user = find_user_by_email(name)
        if user.new_resource?
          say("#{name} unknown", :red)
          exit 1
        end

        user.attributes['name'] = new_name
        unless user.save
          say("#{name} save failed: #{user.errors}", :red)
          exit 1
        end
      end

      desc "delete [USER]@[DOMAIN]", "delete a specified user from the given domain"
      def delete(name)
        user = find_user_by_email(name)
        if user.new_resource?
          say("#{name} unknown", :red)
          exit 1
        end

        unless user.delete
          say("#{name} delete failed: #{user.errors}", :red)
          exit 1
        end
      end
    end
  end
end
