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
  fields:
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

static mrb_value 
mrb_raylib_color_r(mrb_state *mrb, mrb_value self)
{
    Color *obj = DATA_PTR(self);
    return mrb_fixnum_value(obj->r);
}

static mrb_value 
mrb_raylib_color_set_r(mrb_state *mrb, mrb_value self)
{
    mrb_int value;
    mrb_get_args(mrb, "i", &value);

    Color *obj = DATA_PTR(self);
    obj->r = value;

    return mrb_fixnum_value(value);
}

static mrb_value 
mrb_raylib_color_g(mrb_state *mrb, mrb_value self)
{
    Color *obj = DATA_PTR(self);
    return mrb_fixnum_value(obj->g);
}

static mrb_value 
mrb_raylib_color_set_g(mrb_state *mrb, mrb_value self)
{
    mrb_int value;
    mrb_get_args(mrb, "i", &value);

    Color *obj = DATA_PTR(self);
    obj->g = value;

    return mrb_fixnum_value(value);
}

static mrb_value 
mrb_raylib_color_b(mrb_state *mrb, mrb_value self)
{
    Color *obj = DATA_PTR(self);
    return mrb_fixnum_value(obj->b);
}

static mrb_value 
mrb_raylib_color_set_b(mrb_state *mrb, mrb_value self)
{
    mrb_int value;
    mrb_get_args(mrb, "i", &value);

    Color *obj = DATA_PTR(self);
    obj->b = value;

    return mrb_fixnum_value(value);
}

static mrb_value 
mrb_raylib_color_a(mrb_state *mrb, mrb_value self)
{
    Color *obj = DATA_PTR(self);
    return mrb_fixnum_value(obj->a);
}

static mrb_value 
mrb_raylib_color_set_a(mrb_state *mrb, mrb_value self)
{
    mrb_int value;
    mrb_get_args(mrb, "i", &value);

    Color *obj = DATA_PTR(self);
    obj->a = value;

    return mrb_fixnum_value(value);
}



void mrb_raylib_module_init(mrb_state *mrb)
{
    struct RClass *mod_raylib = mrb_define_module(mrb, "Raylib");
    struct RClass *raylib_error_cls = mrb_define_class_under(mrb, mod_raylib, "RaylibError", mrb->eStandardError_class);

    {
        struct RClass *cls = mrb_define_class_under(mrb, mod_raylib, "Color", mrb->object_class);
        MRB_SET_INSTANCE_TT(cls, MRB_TT_DATA);
        mrb_define_method(mrb, cls, "initialize", mrb_raylib_color_initialize, MRB_ARGS_NONE());
        mrb_define_method(mrb, cls, "r", mrb_raylib_color_r, MRB_ARGS_NONE());
        mrb_define_method(mrb, cls, "r=", mrb_raylib_color_set_r, MRB_ARGS_REQ(1));
        mrb_define_method(mrb, cls, "g", mrb_raylib_color_g, MRB_ARGS_NONE());
        mrb_define_method(mrb, cls, "g=", mrb_raylib_color_set_g, MRB_ARGS_REQ(1));
        mrb_define_method(mrb, cls, "b", mrb_raylib_color_b, MRB_ARGS_NONE());
        mrb_define_method(mrb, cls, "b=", mrb_raylib_color_set_b, MRB_ARGS_REQ(1));
        mrb_define_method(mrb, cls, "a", mrb_raylib_color_a, MRB_ARGS_NONE());
        mrb_define_method(mrb, cls, "a=", mrb_raylib_color_set_a, MRB_ARGS_REQ(1));
    }


}
    EOS

    assert_equal(expected, parser.impl_content)
  end
end

class TypeTest < Test::Unit::TestCase
  def test_color
    t = Type.new("Color", ["unsigned char r;", "unsigned char g;", "unsigned char b;", "unsigned char a;"])
    assert_equal "Color", t.name
    assert_equal "color", t.lower_name
    assert_equal 4, t.fields.count
    assert_equal "unsigned char", t.fields[0].type
    assert_equal "r", t.fields[0].name
  end
end 

class FieldTest < Test::Unit::TestCase
  def test_float_field
    field = Field.new("float x")
    assert_equal "f", field.get_args_parameter
    assert_equal "mrb_float_value(mrb, value)", field.to_mrb_value("value")
    assert_equal "mrb_float", field.to_mrb_type
  end
end

class FunctionTest < Test::Unit::TestCase
  def test_close_window
    function = Function.new("void CloseWindow(void);")
    assert_equal "CloseWindow", function.c_name
    assert_equal "close_window", function.ruby_name
    assert_equal "void", function.ret_type
    assert_equal 0, function.arguments.count
  end

  def test_init_window
    function = Function.new("void InitWindow(int width, int height, const char* title);")
    assert_equal "InitWindow", function.c_name
    assert_equal "init_window", function.ruby_name
    assert_equal "void", function.ret_type
    assert_equal 3, function.arguments.count
    assert_equal "int", function.arguments[0].type
    assert_equal "width", function.arguments[0].name
    assert_equal "int", function.arguments[1].type
    assert_equal "height", function.arguments[1].name
    assert_equal "const char*", function.arguments[2].type
    assert_equal "title", function.arguments[2].name
  end

  def test_init_window_impl_content
    function = Function.new("void InitWindow(int width, int height, const char* title);")

    assert_equal(
      '    mrb_define_module_function(mrb, mod_raylib, "init_window", mrb_raylib_init_window, MRB_ARGS_REQ(3));',
      function.impl_content
    )
  end

  def test_init_window_impl_header
    function = Function.new("void InitWindow(int width, int height, const char* title);")

    expected = <<-EOS
static mrb_value
mrb_raylib_init_window(mrb_state *mrb, mrb_value self)
{
    mrb_int width;
    mrb_int height;
    mrb_value title;
    mrb_get_args(mrb, "iiS", &width, &height, &title);

    InitWindow(width, height, RSTRING_PTR(title));

    return self;
}
    EOS

    assert_equal(expected, function.impl_header)
  end

  def test_window_should_close_impl_content
    function = Function.new("bool WindowShouldClose(void);")

    assert_equal(
      "    mrb_define_module_function(mrb, mod_raylib, \"window_should_close\", mrb_raylib_window_should_close, MRB_ARGS_NONE());",
      function.impl_content
    )
  end

  def test_window_should_close_impl_header
    function = Function.new("bool WindowShouldClose(void);")

    expected = <<-EOS
static mrb_value
mrb_raylib_window_should_close(mrb_state *mrb, mrb_value self)
{


    WindowShouldClose();

    return self;
}
    EOS

    assert_equal(expected, function.impl_header)
  end
end
