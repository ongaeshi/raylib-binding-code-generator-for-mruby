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

    expected = <<-EOS
#include "mrb_raylib.h"

#include <mruby/class.h>
#include <mruby/data.h>
#include <mruby/string.h>
#include <mruby/value.h>
#include <raylib.h>
#include <string.h>



void mrb_raylib_module_init(mrb_state *mrb)
{
    struct RClass *mod_raylib = mrb_define_module(mrb, "Raylib");
    struct RClass *raylib_error_cls = mrb_define_class_under(mrb, mod_raylib, "RaylibError", mrb->eStandardError_class);



}
    EOS

    assert_equal(expected, parser.impl_content)
  end

  def test_color_struct
    parser = Parser.new(<<-EOS
- name: struct Color
  field:
    - unsigned char r;
    - unsigned char g;
    - unsigned char b;
    - unsigned char a;
EOS
    )

    expected = <<-EOS
#include "mrb_raylib.h"

#include <mruby/class.h>
#include <mruby/data.h>
#include <mruby/string.h>
#include <mruby/value.h>
#include <raylib.h>
#include <string.h>

const static struct mrb_data_type mrb_raylib_color_type = { "Color", mrb_free };

static mrb_value
mrb_raylib_color_initialize(mrb_state *mrb, mrb_value self)
{
    Color *obj;

    obj = (Color*)mrb_malloc(mrb, sizeof(Color));
    memset(obj, 0, sizeof(Color));

    DATA_TYPE(self) = &mrb_raylib_color_type;
    DATA_PTR(self) = obj;
    return self;
}


void mrb_raylib_module_init(mrb_state *mrb)
{
    struct RClass *mod_raylib = mrb_define_module(mrb, "Raylib");
    struct RClass *raylib_error_cls = mrb_define_class_under(mrb, mod_raylib, "RaylibError", mrb->eStandardError_class);

    {
        struct RClass *cls = mrb_define_class_under(mrb, mod_raylib, "Color", mrb->object_class);
        MRB_SET_INSTANCE_TT(cls, MRB_TT_DATA);
        mrb_define_method(mrb, cls, "initialize", mrb_raylib_color_initialize, MRB_ARGS_NONE());
    }


}
    EOS

    assert_equal(expected, parser.impl_content)
  end
end