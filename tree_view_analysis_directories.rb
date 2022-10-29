unless ARGV.empty?
  puts "#{${PROGRAM_NAME}} | dot -Tpdf >| _.pdf"
  exit
end

pairs = Dir['*']\
  .map{|dir| dir\
    .split('-')}\
  .delete_if(&:one?)\
  .map{|names| names\
    .each_cons(2)\
    .map{|parent, child| "#{parent.inspect} -> #{child.inspect};"}}\
  .join("\n")

puts "digraph {"
puts pairs
puts "}"
