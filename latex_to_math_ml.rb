#!/usr/bin/ruby

require 'math_ml/string'

unless ARGV.empty?
  $stderr.puts <<-EOS
#{File.basename($PROGRAM_NAME)} < INPUT > OUTPUT
# Replace  LaTeX math expressions marked by <imath>...</imath> (inline) or <bmath>...</bmath> (block) to MathML
  EOS

  exit 1
end

INLINE_MATH_REGEXP = /<imath>((?:.|\n)*?)<\/imath>/
BLOCK_MATH_REGEXP = /<bmath>((?:.|\n)*?)<\/bmath>/

puts $stdin.read()\
  .gsub(INLINE_MATH_REGEXP){$1.to_mathml(false)}\
  .gsub(BLOCK_MATH_REGEXP){$1.to_mathml(true)}
