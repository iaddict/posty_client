require 'uri'

module PostyClient
  module Resources
    # @abstract
    class Base
      include ActiveSupport::Benchmarkable

      cattr_accessor :logger do
        PostyClient.logger
      end

      cattr_accessor :rejected_attributes do
        [:id, :virtual_domain_id, :created_at, :updated_at, :password]
      end

      def self.base_uri
        URI.join(Settings.api_url, Settings.api_version)
      end

      def base_uri
        self.class.base_uri
      end

      class_attribute :primary_key
      self.primary_key = 'name'

      attr_reader :name
      attr_reader :attributes
      attr_reader :errors

      attr_accessor :new_resource

      def new_resource?
        @new_resource
      end

      def attributes=(attributes)
        @attributes = attributes.reject {|k,v| rejected_attributes.include?(k.to_sym)} # we only want the value
        @name ||= @attributes[primary_key]
        @attributes
      end

      def load(params: {})
        @new_resource = true
        @attributes = {}

        response = rest_client.get(slug, params)

        if response.status == 404
          logger.debug("#{self.class.name} :: load non existing object (#{response.status}) '#{response.inspect}'")
          return
        elsif response.status != 200
          logger.error("#{self.class.name} :: load failed with (#{response.status}) '#{response}'")
          return
        end

        @new_resource = false
        datum = response.body
        # datum is either {model_name: {...attributes}} or {...attributes}
        self.attributes = datum.count == 1 ? datum.flatten.last : datum

        @name = attributes[primary_key]

        self
      end

      def save
        if new_resource?
          self.attributes[primary_key] = @name
          if create
            @new_resource = false
            return true
          end
        else
          if update
            load
            return true
          end
        end

        false
      end

      def update
        logger.debug("update #{self.class.name} : #{name}")
        request_with_error_handling do
          rest_client.put(slug, attributes)
        end
      end

      def create
        logger.debug("create #{self.class.name} : #{name}")
        request_with_error_handling do
          rest_client.post(resource_slug, attributes)
        end
      end

      def delete
        logger.debug("delete #{self.class.name} : #{name}")
        request_with_error_handling do
          rest_client.delete(slug)
        end
      end

      def request_with_error_handling(&block)
        response = begin
          block.call
        end

        case response.status
        when 200..299
          true
        else
          @errors = begin
            response.body['error']
          rescue => e
            logger.error(e)
            {'base' => "Unrecoverable error: #{response.status} (#{response})"}
          end

          false
        end
      end

      def self.resource_name
        self.name&.demodulize&.tableize
      end

      def resource_name
        self.class.resource_name
      end

      # @return [String] the url of the resource namespace, eg. /domains/abc.de/forwarders
      def resource_slug
        raise NotImplementedError        
      end

      # @return [String] the url of the concrete resource, eg. /domains/abc.de/forwarders/fw1
      def slug
        raise NotImplementedError
      end

      private

      # @param [Array<Hash>] array_of_attributes
      # @param [Class<Base>] resource_class
      # @return [Array<Base>, nil]
      def map_when_present(array_of_attributes, resource_class)
        return nil if array_of_attributes.nil?
        array_of_attributes.map { |mb| resource_class.new(self).tap { _1.attributes = mb } }
      end

      # @return [Faraday::Connection]
      def self.rest_client
        Faraday.new(
          url: base_uri,
          headers: {'Auth-Token' => PostyClient::Settings.access_token}
        ) do |f|
          f.request :json # encode req bodies as JSON and automatically set the Content-Type header
          f.response :json # decode response bodies as JSON
        end
      end

      delegate :rest_client, to: self
    end
  end
end