require_relative 'finder_concern'

module PostyClient
  module Resources
    class UserAlias < Base
      extend FinderConcern

      attr_reader :user

      def initialize(user, name=nil)
        @user = user
        @name = name
        load if name
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [user.slug, 'aliases'].join('/')
      end
      
      def self.resource_name
        :aliases
      end
    end
  end
end
