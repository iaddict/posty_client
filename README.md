posty_client
============

Client library for the post_api server: https://github.com/posty/posty_api


Usage
-----

```
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

u = PostyClient::Resources::Alias.new(d, 'tommy')
u.attributes['destination'] = 'bheller'
unless u.save
  pp u.errors
  exit
end

puts '--'*10
pp d.aliases
```