require_relative 'finder_concern'

module PostyClient
  module Resources
    class User < Base
      extend FinderConcern

      attr_reader :domain

      def initialize(domain, name=nil)
        @name = name
        @domain = domain
        load if name
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [domain.slug, 'users'].join('/')
      end
    end
  end
end