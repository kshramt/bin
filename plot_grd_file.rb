#/bin/sh -ue

exec ${MY_RUBY} -w -x "$0" "$@"

#!/usr/bin/ruby

require 'optparse'

VERSION = '0.0.0'

def usage_and_exit(exit_status)
  system "#{$PROGRAM_NAME} --help"
  exit(exit_status)
end

def parse_grdinfo(grd_file)
  raise IOError, "#{grd_file} not readable" unless File.readable?(grd_file)

  names = %w[file w e s n z0 z1 dx dy nx ny x0 y0 x1 y1 med scale mean std rms n_nan].map(&:to_sym)
  types = %w[s f f f f f f f f i i f f f f f f f f f i].map{|t| "to_#{t}"}
  raw_values = `GMT grdinfo -C -M -L1 -L2 #{grd_file}`.split
  Hash[]
  names_to_values = names.zip(types, raw_values)\
    .map{|n, t, v| [n, v.__send__(t)]}

  Hash[names_to_values]
end

op = OptionParser.new()
opts = {}
op.on('-f', '--file=FILE', 'A grd file name to plot.'){|v| opts[:f] = v}
op.on('-n', '--n_contour=N_CONTOUR', 'Number of cotours to plot'){|v| opts[:n] = v.to_i}
op.parse!

GRD_FILE = opts[:f] || usage_and_exit(1)
N_CONTOUR = opts[:n] || 10

GRD_INFO = parse_grdinfo(GRD_FILE)
RANGES = "#{GRD_INFO[:w]}/#{GRD_INFO[:e]}/#{GRD_INFO[:s]}/#{GRD_INFO[:n]}"
ZS = "#{GRD_INFO[:z0]}/#{GRD_INFO[:z1]}/#{(GRD_INFO[:z1] - GRD_INFO[:z0]).abs/200.0}"
Z_INC = "#{(GRD_INFO[:z1] - GRD_INFO[:z0]).abs.to_f/N_CONTOUR}"
TICK_INTERVAL = "#{((GRD_INFO[:e] - GRD_INFO[:w])/5.0).abs}/#{((GRD_INFO[:n] - GRD_INFO[:s])/5.0).abs}"

COMMAND = <<EOS
GMT gmtset PAPER_MEDIA a4+
GMT gmtset PAGE_ORIENTATION portrait
GMT gmtset MEASURE_UNIT cm
GMT gmtset PLOT_DEGREE_FORMAT D

readonly CPT_FILE=$(mktemp)

GMT makecpt \
    -Crainbow \
    -T#{ZS} \
    > ${CPT_FILE}

{
    GMT psbasemap \
        -JX15c \
        -R#{RANGES} \
        -B#{TICK_INTERVAL} \
        -U \
        -K
    GMT grdimage \
        #{GRD_FILE} \
        -JX \
        -R \
        -C${CPT_FILE} \
        -Sb \
        -U \
        -O \
        -K
    GMT grdcontour \
        #{GRD_FILE} \
        -JX \
        -R \
        -C#{Z_INC} \
        -S10 \
        -O
}
EOS

system(COMMAND)
