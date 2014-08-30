VALS = %w[w e s n z0 z1 dx dy nx ny]

if ARGV.size != 2
  $stderr.puts "#{$PROGRAM_NAME} GRD_FILE COMMAND"
  $stderr.puts "Example: #{$PROGRAM_NAME} ~/data/plate_data/pl_plate.grd " + '\'-R#{w}/#{e}/#{s}/#{n}\''
  $stderr.puts "Values: #{VALS.join(', ')}"
  $stderr.puts "See also: GMT grdinfo --help"
  exit 1
end

GRD_FILE = ARGV[0]
bind = binding()

VALS.zip(`GMT grdinfo -C #{GRD_FILE}`.split[1..-1])\
  .each{|k, v| eval("def #{k}; #{v}; end", bind)}

CODE = ARGV[1]
puts(eval('"' + CODE + '"'))
