require 'yaml'
require_relative 'parser'

if $0 == __FILE__
  parser = Parser.new(File.read(ARGV[0]))
  puts parser.impl_content
  # puts parser.ruby_content
end
