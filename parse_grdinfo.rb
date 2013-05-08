#!/bin/sh

set -o nounset
set -o errexit
set -o pipefail

exec ${MY_RUBY} -x "$0" "$@"

#!/usr/bin/ruby

VALS = %w[w e s n z0 z1 dx dy nx ny x0 y0 x1 y1 med scale mean std rms n_nan]

if ARGV.size != 2
  $stderr.puts "#{$PROGRAM_NAME} GRD_FILE COMMAND"
  $stderr.puts "Example: #{$PROGRAM_NAME} ~/data/plate_data/pl_plate.grd " + '\'-R#{w}/#{e}/#{s}/#{n}\''
  $stderr.puts "Values: #{VALS.join(', ')}"
  $stderr.puts "See also: GMT grdinfo --help"
  exit 1
end

GRD_FILE = ARGV[0]
bind = binding()

VALS.zip(`GMT grdinfo -C -M -L1 -L2 #{GRD_FILE}`.split[1..-1])\
  .each{|k, v| eval("def #{k}; #{v}; end", bind)}

CODE = ARGV[1]
puts(eval('"' + CODE + '"'))
