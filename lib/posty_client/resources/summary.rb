module PostyClient
  module Resources
    class Summary < Base
      def self.get
        response = RestClient.get([base_uri, resource_name].join('/'))

        data = JSON.parse(response)
      end
      
      def self.resource_name
        :summary
      end
    end
  end
end