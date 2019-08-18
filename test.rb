require_relative "raylib-binding-code-generator-for-mruby"
require "test/unit"

class ParserTest < Test::Unit::TestCase
  def test_empty_string
    parser = Parser.new("")
    assert_equal "", parser.header_content
  end
end