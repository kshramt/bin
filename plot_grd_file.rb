#/bin/sh -ue

exec ${MY_RUBY} -w -x "$0" "$@"

#!/usr/bin/ruby

require 'optparse'

VERSION = '0.0.0'

def usage_and_exit(usage, exit_status)
  if exit_status == 0
    $stdout.puts usage
  else
    $stderr.puts usage
  end
  exit exit_status
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

N_CONTOUR_DEFAULT = 10
CPT_DEFAULT = 'rainbow'

op = OptionParser.new()
opts = {}
op.on('-f', '--file=FILE', 'A grd file name to plot.'){|v| opts[:f] = v}
op.on('-n', '--n_contour=N_CONTOUR', "Number of cotours to plot [#{N_CONTOUR_DEFAULT}]"){|v| opts[:n] = v.to_i}
op.on('-c', '--cpt=COLOR_PALETTE', "Color palette [#{CPT_DEFAULT}]"){|v| opts[:c] = v}
op.parse!
HELP = op.help

GRD_FILE = opts[:f] || usage_and_exit(HELP, 1)
N_CONTOUR = opts[:n] || N_CONTOUR_DEFAULT
CPT = opts[:c] || CPT_DEFAULT

GRD_INFO = parse_grdinfo(GRD_FILE)
w = GRD_INFO[:w]
e = GRD_INFO[:e]
s = GRD_INFO[:s]
n = GRD_INFO[:n]
z0 = GRD_INFO[:z0]
z1 = GRD_INFO[:z1]
RANGES = "#{w}/#{e}/#{s}/#{n}"
ZS = "#{z0}/#{z1}/#{(z1 - z0).abs/200.0}"
Z_INC = (z1 - z0).abs.to_f/N_CONTOUR
TICK_INTERVAL = "#{((e - w)/5.0).abs}/#{((n - s)/5.0).abs}"

COMMAND = <<EOS
GMT gmtset PAPER_MEDIA a4+
GMT gmtset PAGE_ORIENTATION portrait
GMT gmtset MEASURE_UNIT cm
GMT gmtset PLOT_DEGREE_FORMAT D

readonly CPT_FILE=$(mktemp)

GMT makecpt \
    -C#{CPT} \
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
