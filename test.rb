require_relative 'raylib-binding-code-generator-for-mruby'
require 'test/unit'

class ParserTest < Test::Unit::TestCase
  def test_header_content
    parser = Parser.new("")

    expected = <<-EOS
#ifndef MRB_RAYLIB__H
#define MRB_RAYLIB__H

#include <mruby.h>

#ifdef __cplusplus
#define MRB_RAYLIB_API extern "C"
#else
#define MRB_RAYLIB_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

MRB_RAYLIB_API void mrb_raylib_module_init(mrb_state *mrb);

#ifdef __cplusplus
}
#endif

#endif // MRB_RAYLIB__H
    EOS

    assert_equal(expected, parser.header_content)
  end

  def test_empty_string
    parser = Parser.new("")

    expected = <<EOS
EOS

    assert_equal(expected, parser.impl_content)
  end
end