module PostyClient
  module Resources
    class Domain < Base

      def self.all
        response = rest_client.get([base_uri, resource_name].join('/'))

        return nil unless response.status == 200

        data = response.body

        data.collect do |datum|
          model = self.new
          model.attributes = datum.flatten.last
          model.new_resource = false

          model
        end
      end

      # @param [nil,String] name
      # @param [Hash] params
      # @option params [Boolean] :complete to fetch the domain with all associations
      def initialize(name=nil, params: {})
        @name = name
        load(params: params) if name
      end

      # @return [Array<User>]
      def users
        map_when_present(@attributes['mailboxes'], User) || User.find_all_by(self)
      end

      # @return [Array<DomainAlias>]
      def aliases
        map_when_present(@attributes['domain_aliases'], DomainAlias) || DomainAlias.find_all_by(self)
      end

      # @return [Array<DomainForwarder>]
      def forwarders
        map_when_present(@attributes['forwarders'], DomainForwarder) || DomainForwarder.find_all_by(self)
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [base_uri, 'domains'].join('/')
      end
    end
  end
end