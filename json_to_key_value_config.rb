#!/usr/bin/ruby

require 'json'

require 'key_value_config'

puts ::KeyValueConfig.dump(::JSON.load($stdin.read()))
