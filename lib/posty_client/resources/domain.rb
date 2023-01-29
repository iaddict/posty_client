module PostyClient
  module Resources
    class Domain < Base

      def self.all
        response = RestClient.get([base_uri, resource_name].join('/'))

        return nil unless response.code == 200

        data = JSON.parse(response)

        data.collect do |datum|
          model = self.new
          model.attributes = datum.flatten.last
          model.new_resource = false

          model
        end
      end

      def initialize(name=nil, params: {})
        @name = name
        load(params: params) if name
      end

      def users
        map_when_present(@attributes['mailboxes'], User) || User.find_all_by(self)
      end

      def aliases
        map_when_present(@attributes['domain_aliases'], DomainAlias) || DomainAlias.find_all_by(self)
      end

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