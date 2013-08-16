module PostyClient
  module Resources
    class Transport < Base

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

      def initialize(name=nil)
        @name = name
        load if name
      end

      def slug
        [resource_slug, name].join('/')
      end

      def resource_slug
        [base_uri, 'transports'].join('/')
      end
    end
  end
end