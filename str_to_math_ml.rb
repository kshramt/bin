require 'math_ml/string'

unless ARGV.empty?
  $stderr.puts "#{$PROGRAM_NAME} < LATEX_MATH_INPUT > MATHML_OUTPUT"
  exit
end

puts $stdin.read.to_mathml
