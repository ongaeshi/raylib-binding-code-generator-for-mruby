require "open-uri"
require "yaml"
require_relative "parser"

if $0 == __FILE__
  yml, url = ARGV
  parser = Parser.new(File.read(yml))
  src = open(url).read

  puts parser.convert_raylib_example(src)
end
