module PostyClient
  module Resources
    module FinderConcern
      # @param [PostyClient::Resource::Base] resource
      def find_all_by(resource)
        response = rest_client.get([resource.slug, resource_name].join('/'))

        if response.status == 404
          logger.debug("#{self.class.name} :: load non existing object (#{response.status}) '#{response}'")
          return []
        elsif response.status != 200
          logger.error("#{self.class.name} :: load failed with (#{response.status}) '#{response}'")
          return nil
        end

        data = response.body

        data.collect do |datum|
          model = self.new(resource)
          # a Hash is returned with regular Grape collection responses, the former is the old format
          # datum is either {model_name: {...attributes}} or {...attributes}
          model.attributes = datum.count == 1 ? datum.flatten.last : datum
          model.new_resource = false

          model
        end
      end
    end
  end
end