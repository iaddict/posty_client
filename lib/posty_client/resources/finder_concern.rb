module PostyClient
  module Resources
    module FinderConcern
      def find_all_by_domain(domain)
        response = RestClient.get([domain.slug, resource_name].join('/'))

        if response.code == 404
          logger.debug("#{self.class.name} :: load non existing object (#{response.code}) '#{response}'")
          return []
        elsif response.code != 200
          logger.error("#{self.class.name} :: load failed with (#{response.code}) '#{response}'")
          return nil
        end

        data = JSON.parse(response)

        data.collect do |datum|
          model = self.new(domain)
          model.attributes = datum.flatten.last
          model.new_resource = false

          model
        end
      end
    end
  end
end