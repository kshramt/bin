if ARGV.size > 0 && %w[-h --help].include?(ARGV.first)
  puts "rake -P | #{$PROGRAM_NAME} | dot -Tpdf > OUTPUT"
  exit
end

buf = $stdin\
  .read()\
  .split(/(?:\A|\n)rake/)\
  .delete_if(&:empty?)\
  .map{|group|
    arr = group.split("\n").map(&:strip)
    [arr.first, arr.drop(1)]}

nodes = buf\
  .flatten\
  .uniq\
  .map{|name|
     case name
     when /\/bin\//
       "#{name.inspect} [color = red]"
     when /\.(eps|pdf)\z/
       "#{name.inspect} [color = blue]"
     end}\
  .join("\n")

pairs = buf\
  .map{|parent, children|
    children.map{|child|
      "#{parent.inspect} -> #{child.inspect};"}\
    .join("\n")}\
  .join("\n")

puts <<-EOS
digraph {
  graph [rankdir = LR];
  node [shape = box]
  #{nodes}
  #{pairs}
}
EOS
