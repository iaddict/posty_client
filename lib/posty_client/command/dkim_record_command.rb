# frozen_string_literal: true
module PostyClient
  module Command
    class DkimRecordCommand < Thor
      include PostyClient::Resources
      include ServerOptionConcern

      desc "list", "list all dkim keys"

      DEFAULT_UPDATED_SINCE = Time.now - 24 * 60 * 60
      method_option :updated_since, default: DEFAULT_UPDATED_SINCE, aliases: "-u", desc: "Only show records which have been updated since the given date. Format like YYYY-MM-DD [HH:MM[:SS]."
      def list
        updated_since = begin
          Time.parse(options[:updated_since].to_s)
        rescue => e
          say("Given date is invalid: #{e}", :red)
          exit(1)
        end

        api_keys = PostyClient::Resources::DkimRecord
          .all(updated_since: updated_since)
          .map { |d| [
            d.attributes["domain"],
            d.attributes["txt_record_domain"],
            d.attributes["txt_record_data"],
            d.attributes["txt_record_ttl"],
            d.attributes["updated_at"],
            set_color(d.attributes["active"], d.active? ? :green : :red)
          ] }

        api_keys.unshift(["Domain", "TXT Record Name", "TXT Record Data", "TXT Record TTL", "Updated", "Active"])
        print_table(api_keys)
      end
    end
  end
end
