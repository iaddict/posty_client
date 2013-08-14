require_relative 'finder_concern'

module PostyClient
  module Resources
    class DomainAlias < Base
      extend FinderConcern

      attr_reader :domain

      def initialize(domain, name=nil)
        @domain = domain
        @name = name
        load if name
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [domain.slug, 'aliases'].join('/')
      end
      
      def self.resource_name
        :aliases
      end
    end
  end
end