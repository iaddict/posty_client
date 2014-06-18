# posty\_client

posty\_client is a client library and command line tool for the post\_api server: [https://github.com/posty/posty_api](https://github.com/posty/posty_api)

## Install

    $ gem install posty\_client

## Usage

You need to create at least a configuration file at `~/.posty-cli.yml`.
It contains the details how to connect to your api server.

The cli supplies a command to create a template for you:

    $ posty-client create_config

### Cli usage

    $ posty-client help

### Library usage examples


	require 'pp'

	ENV['RESTCLIENT_LOG'] = 'stdout'
	
	$: << '.'
	require 'lib/posty_client.rb'
	
	d = PostyClient::Resources::Domain.new('posty-soft1.org')
	puts d.name, d.primary_key
	pp d.attributes
	
	unless d.save
	  pp d.errors
	end
	
	d = PostyClient::Resources::Domain.new('posty-soft.org')
	unless d.save
	  pp d.errors
	end
	
	puts '--'*10
	
	pp d.users
	
	puts '*'*20
	
	u = PostyClient::Resources::User.new(d, 'to')
	u.attributes['password'] = 'lalalala'
	unless u.save
	  pp u.errors
	  exit
	end
	
	a = PostyClient::Resources::UserAlias.new(u, 'tommy')
	a.attributes['destination'] = 'bheller'
	unless a.save
	  pp a.errors
	  exit
	end
	
	puts '--'*10
	pp u.aliases

## Information

For more information about posty please visit our website:
[www.posty-soft.org](http://www.posty-soft.org)

## Support

* IRC
	* Server: irc.freenode.net
	* Channel: #posty
* Email:
	* support@posty-soft.org

## Bug reports

If you discover any bugs, feel free to create an issue on GitHub. Please add as much information as possible to help us fixing the possible bug. We also encourage you to help even more by forking and sending us a pull request.

## License

MIT License. See LICENSE for details.
