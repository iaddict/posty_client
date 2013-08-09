require 'thor'
require 'posty_client/command/domain_command'
require 'posty_client/command/user_command'
require 'posty_client/command/alias_command'


module PostyClient
  class CLI < Thor
    map "-v" => "version"
    map "--version" => "version"

    desc "--version", "print version"
    long_desc "Print the Posty CLI tool version"
    def version
      puts "version %s" % [PostyClient::VERSION]
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

    desc "alias [SUBCOMMAND]", "perform an action on a alias"
    long_desc <<-D 
    Perform an action on a alias. To see available subcommands use 'posty alias help' 
    D
    subcommand "alias", PostyClient::Command::AliasCommand
  end
end


