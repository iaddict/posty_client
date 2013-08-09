require 'uri'
require 'rest_client'

module PostyClient
  module Resources
    class Base
      cattr_accessor :logger do
        PostyClient.logger
      end

      cattr_accessor :rejected_attributes do
        [:id, :virtual_domain_id, :created_at, :updated_at, :password]
      end

      cattr_accessor :base_uri do
        URI.join(Settings.api_url, Settings.api_version)
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

      def load
        @new_resource = true
        @attributes = {}

        response = begin
          RestClient.get(slug)
        rescue RestClient::Exception => e
          e.response
        end

        if response.code == 404
          logger.debug("#{self.class.name} :: load non existing object (#{response.code}) '#{response}'")
          return
        elsif response.code != 200
          logger.error("#{self.class.name} :: load failed with (#{response.code}) '#{response}'")
          return
        end

        @new_resource = false
        self.attributes = JSON.parse(response).flatten.last

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

        return false
      end

      def update
        logger.debug("update #{self.class.name} : #{name}")
        request_with_error_handling do
          RestClient.put(slug, attributes)
        end
      end

      def create
        logger.debug("create #{self.class.name} : #{name}")
        request_with_error_handling do
          RestClient.post(resource_slug, attributes, :content_type => :json, :accept => :json)
        end
      end

      def delete
        logger.debug("delete #{self.class.name} : #{name}")
        request_with_error_handling do
          RestClient.delete(slug)
        end
      end

      def request_with_error_handling(&block)
        response = begin
          block.call
        rescue RestClient::Exception => e
          e.response
        end

        case response.code
        when 200..299
          true
        else
          @errors = begin
            JSON.parse(response)['error']
          rescue => e
            logger.error(e)
            {'base' => "Unrecoverable error: #{response.code} (#{response})"}
          end

          false
        end
      end

      def self.resource_name
        self.name.demodulize.tableize        
      end

      def resource_name
        self.class.resource_name
      end

      def resource_slug
        raise NotImplementedError        
      end

      def slug
        raise NotImplementedError
      end
    end
  end
end