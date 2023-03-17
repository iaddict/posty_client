require 'thor'
require 'posty_client/command/domain_command'
require 'posty_client/command/user_command'
require 'posty_client/command/domain_alias_command'
require 'posty_client/command/user_alias_command'
require 'posty_client/command/transport_command'
require 'posty_client/command/forwarder_command'
require 'posty_client/command/api_key_command'
require 'posty_client/command/dkim_record_command'

module PostyClient
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    map "-v" => "version"
    map "--version" => "version"

    desc "--version", "print version"
    long_desc "Print the Posty CLI tool version"
    def version
      puts "version %s" % [PostyClient::VERSION]
    end

    desc "create_config", "create a configuration file at ~/.posty-client.yml"
    def create_config
      require 'fileutils'

      user_config_file = File.expand_path('~/.posty_client.yml')
      if File.exists?(user_config_file)
        say("File #{user_config_file} already exists! Nothing created.", :red)
        exit 1
      end

      FileUtils.cp(PostyClient.root + '/config/posty_client.yml.dist', user_config_file)
      say("File #{user_config_file} created. Please customize.", :green)
    end
    
    desc "summary", "Returns a summary of all Resources"
    def summary
      print_table(PostyClient::Resources::Summary.get)
    end

    desc "domain [SUBCOMMAND]", "perform an action on a domain"
    long_desc <<-D 
    Perform an action on a domain. To see available subcommands use 'posty domain help' 
    D
    subcommand "domain", PostyClient::Command::DomainCommand

    desc "user [SUBCOMMAND]", "perform an action on a user"
    long_desc <<-D 
    Perform an action on a User. To see available subcommands use 'posty user help' 
    D
    subcommand "user", PostyClient::Command::UserCommand

    desc "domain_alias [SUBCOMMAND]", "perform an action on a domain_alias"
    long_desc <<-D 
    Perform an action on a domain_alias. To see available subcommands use 'posty domain_alias help' 
    D
    subcommand "domain_alias", PostyClient::Command::DomainAliasCommand

    desc "user_alias [SUBCOMMAND]", "perform an action on a user_alias"
    long_desc <<-D 
    Perform an action on a user_alias. To see available subcommands use 'posty user_alias help' 
    D
    subcommand "user_alias", PostyClient::Command::UserAliasCommand

    desc "transport [SUBCOMMAND]", "DEPRECATED: perform an action on a transport"
    long_desc <<-D 
    Perform an action on a transport. To see available subcommands use 'posty transport help' 
    D
    subcommand "transport", PostyClient::Command::TransportCommand

    desc "forwarder [SUBCOMMAND]", "perform an action on a forwarder"
    long_desc <<-D
    Perform an action on a forwarder. To see available subcommands use 'posty forwarder help'
    D
    subcommand "forwarder", PostyClient::Command::ForwarderCommand

    desc "api_key [SUBCOMMAND]", "perform an action on an api_key"
    long_desc <<-D 
    Perform an action on an api_key. To see available subcommands use 'posty api_key help' 
    D
    subcommand "api_key", PostyClient::Command::ApiKeyCommand

    desc "dkim_record [SUBCOMMAND]", "perform an action on an dkim_key"
    long_desc <<-D
    Perform an action on DKIM DNS TXT records. To see available subcommands use 'posty dkim_record help'
    D
    subcommand "dkim_record", PostyClient::Command::DkimRecordCommand
  end
end


