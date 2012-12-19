# = Input format
#   1.0 2
#   3 4.0
#   5 6
#   >
#   7 8
#   8.003 7

SEPARATOR = '>'
JOINT = "\n#{SEPARATOR}\n"

if ARGV.size <= 0 || %w[-h --help].include?(ARGV[0])
  puts "#{ENV['MY_RUBY'] || "ruby"} #{__FILE__} LEN_MAX < multisegment_lines.dat"
  exit 0
end

LEN_MAX = ARGV[0].to_f
if LEN_MAX <= ::Float::EPSILON
  $stderr.puts "Invalid LEN_MAX: #{ARGV[0]}"
  exit 1
end

def divide(p1, p2, len_max)
  raise ArgumentError, "len_max too small: #{len_max}" if len_max <= ::Float::EPSILON

  len_x = p2[0] - p1[0]
  len_y = p2[1] - p1[1]
  n_sub_lines = (Math.hypot(len_x, len_y)/len_max + 1).to_i
  len_x_sub = len_x/n_sub_lines
  len_y_sub = len_y/n_sub_lines

  (0..n_sub_lines)\
    .map{|ith| [p1[0] + ith*len_x_sub, p1[1] + ith*len_y_sub]}\
    .each_cons(2)
end

puts $stdin\
  .read\
  .split(SEPARATOR)\
  .map{|multisegment_line| multisegment_line\
    .strip
    .split("\n")\
    .map{|point| point\
      .split\
      .map(&:to_f)}\
    .each_cons(2)\
    .map{|p1, p2| divide(p1, p2, LEN_MAX)}\
    .map{|lines| lines\
      .map{|p1_p2| p1_p2\
        .map{|point| point.join("\t")}\
        .join("\n")}}}\
  .flatten\
  .join(JOINT)
