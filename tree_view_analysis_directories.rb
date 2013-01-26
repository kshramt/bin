#!/usr/bin/ruby
raise "graphvis is not installed." unless system "dot -V"

format = ARGV.first || 'svg'
if %w[-h --help].include? format
  puts "#{$PROGRAM_NAME} [FORMAT = svg]"
  puts "  FORMAT: pdf, svg"
  exit
end
raise "Unknown formt: #{format}" unless ['pdf', 'svg'].include? format

pairs = Dir['*']\
  .map{|dir| dir\
    .split('-')}\
  .delete_if(&:one?)\
  .map{|names| names\
    .each_cons(2)\
    .map{|parent, child| "#{parent.inspect} -> #{child.inspect};"}}\
  .join("\n")

system <<-EOS
dot -T#{format} <<-EOF
digraph {
#{pairs}
}
EOF
EOS
