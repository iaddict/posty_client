module PostyClient
  module Command
    # frozen_string_literal: true

    module ServerOptionConcern
      extend ActiveSupport::Concern

      included do
        class_option :server, desc: "Choose a server other then the default server, eg. #{Settings.servers.join(', ')}"

        def initialize(args, local_options, config)
          super
          if options[:server].present?
            unless Settings.servers.include?(options[:server])
              say "# Unknown server setting #{options[:server]}. Possible values are #{Settings.servers.join(', ')}.", :red
              exit 1
            end

            say "# Using server settings for #{options[:server]}"
            Settings.current_server = options[:server]
          end
        end
      end
    end
  end
end

