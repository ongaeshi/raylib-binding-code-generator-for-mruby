class Parser
  def initialize(src)
  end

  def header_content
    <<-EOS
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
  end

  def impl_content
    <<-EOS
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
  end
end
