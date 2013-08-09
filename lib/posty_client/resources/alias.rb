module PostyClient
  module Resources
    class Alias < Base
      extend FinderConcern

      attr_reader :domain

      self.primary_key = 'source'

      def initialize(domain, name=nil)
        @domain = domain
        @name = name
        if @name
          unless load
            attributes[primary_key] = @name
          end
        end
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [domain.slug, 'aliases'].join('/')
      end
    end
  end
end