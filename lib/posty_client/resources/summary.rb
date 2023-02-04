module PostyClient
  module Resources
    class Summary < Base
      def self.get
        response = rest_client.get([base_uri, resource_name].join('/'))
        response.body
      end
      
      def self.resource_name
        :summary
      end
    end
  end
end