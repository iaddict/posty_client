module PostyClient
  module Command
    module FinderConcerns
      include PostyClient::Resources

      def user_and_domain_from_email(email)
        parts = email.split("\@")

        unless parts.size == 2
          say("#{email} not an email address", :red)
          exit 1
        end

        return *parts
      end

      def find_domain_by_name(name)
        domain = Domain.new(name)
        if domain.new_resource?
          say("Unknown domain #{name}", :red)
          exit 1
        end

        domain        
      end

      def find_user_by_email(name)
        user_name, domain_name = user_and_domain_from_email(name)
        domain = find_domain_by_name(domain_name)

        User.new(domain, user_name)
      end
      
      def find_user_alias_by_email_and_name(email, name)
        user = find_user_by_email(email)
        
        UserAlias.new(user, name)
      end
      
      def find_domain_alias_by_domain_and_name(domain_name, name)
        domain = find_domain_by_name(domain_name)
        
        DomainAlias.new(domain, name)
      end
    end
  end
end