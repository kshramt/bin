sum = $stdin.read\
  .split\
  .map(&:to_f)\
  .reduce(&:+)

puts sum || 0
