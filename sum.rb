sum = $stdin.read\
  .split\
  .map(&:to_f)\
  .reduce(&:+)

puts(if sum.nil?
       0
     else
       sum
     end)
