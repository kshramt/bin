#!/usr/bin/ruby
puts 'digraph {'
pairs = Dir['*']\
  .map{|dir| dir\
    .split('-')}\
  .delete_if(&:one?)\
  .each{|dirs| dirs\
    .each_cons(2){|pair| puts "#{pair[0].inspect} -> #{pair[1].inspect};"}}
puts '}'
