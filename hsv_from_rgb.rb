#!/bin/sh -u
exec ${MY_RUBY} -x "$0" "$@"

#!/usr/bin/ruby

unless ARGV.size == 3
  puts "hsv_from_rgb.rb r g b"
  exit
end

r, g, b = ARGV.map(&:to_f)

raise "r is out of range: #{r}" unless (0..255).cover?(r)
raise "g is out of range: #{g}" unless (0..255).cover?(g)
raise "b is out of range: #{b}" unless (0..255).cover?(b)

mini, maxi = [r, g, b].minmax
delta = (maxi - mini)
h = if mini >= maxi
      0
    else
      if r >= maxi
        60*(g - b)/delta
      elsif g >= maxi
        60*(b - r)/delta + 120
      elsif b >= maxi
        60*(r - g)/delta + 240
      else
        raise 'Must not happen.'
      end
    end
h += 360 if h < 0

s = if maxi > ::Float::EPSILON
      delta/maxi
    else
      0
    end

v = maxi/255

puts [h, s, v].join(' ')
