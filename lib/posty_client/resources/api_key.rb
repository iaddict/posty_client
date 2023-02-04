module PostyClient
  module Resources
    class ApiKey < Base

      attr_reader :access_token
      
      self.primary_key = 'access_token'

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

      def initialize(name=nil)
        @name = name
        load if name
      end
      
      def expired?
        attributes['expires_at'].to_time <= DateTime.now
      end
      
      def active?
        attributes['active']
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [base_uri, 'api_keys'].join('/')
      end
    end
  end
end