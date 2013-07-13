require 'optparse'

require 'math_ml/string'

VERSION = '0.0.0'

def main(args)
  parser = OptionParser.new()
  parser.version = VERSION
  opts = {}
  parser.on('-b', '--block', 'Display style is block'){|v| opts['--block'] = v}
  parser.banner = <<-EOS
# Convert LaTeX math expressions read from STDIN to MathML
#{File.basename($PROGRAM_NAME, '.rb')} [options] < LATEX_MATH_FILE > MATH_ML_FILE
  EOS

  parser.parse!(args.dup)

  puts $stdin.read.to_mathml(opts['--block'])
end

if __FILE__ == $PROGRAM_NAME
  main(ARGV)
end
