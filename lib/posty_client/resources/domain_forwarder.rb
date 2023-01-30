require_relative 'finder_concern'

module PostyClient
  module Resources
    class DomainForwarder < Base
      extend FinderConcern

      attr_reader :domain

      def initialize(domain, name=nil)
        @domain = domain
        @name = name
        load if name
      end

      # @return [Array<String>] destinations with @domain.name even when local mailboxes
      def fully_qualified_destinations
        attributes["destination"].to_s.
          split(/[,\n]/).
          map(&:strip).
          reject(&:blank?).
          map { |dest| dest.include?("@") ? dest : "#{dest}@#{domain.name}" }
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [domain.slug, 'forwarders'].join('/')
      end

      def self.resource_name
        :forwarders
      end
    end
  end
end