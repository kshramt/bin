#!/bin/ruby

require 'json'

require 'key_value_config'

puts ::JSON.dump(::KeyValueConfig.load($stdin.read()))
