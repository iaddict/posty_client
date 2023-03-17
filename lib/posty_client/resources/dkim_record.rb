module PostyClient
  module Resources
    class DkimRecord < Base
      cattr_accessor :rejected_attributes do
        []
      end

      # @param [Time] updated_since
      # @return [Array<DkimRecord>] or nil when the request has failed
      def self.all(updated_since: nil)
        params = {}
        params[:updated_since] = updated_since.to_s if updated_since.present?

        response = rest_client.get([base_uri, resource_name].join('/'), params)

        return nil unless response.status == 200

        data = response.body

        data.collect do |datum|
          model = self.new
          model.attributes = datum
          model.new_resource = false

          model
        end
      end

      def active?
        attributes["active"] == true
      end
    end
  end
end
