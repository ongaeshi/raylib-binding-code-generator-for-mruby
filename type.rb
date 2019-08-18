class Type
  def initialize(name)
  end

  def impl_header
    <<-EOS
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
    EOS
  end

  def impl_content
    <<-EOS
    {
        struct RClass *cls = mrb_define_class_under(mrb, mod_raylib, "Color", mrb->object_class);
        MRB_SET_INSTANCE_TT(cls, MRB_TT_DATA);
        mrb_define_method(mrb, cls, "initialize", mrb_raylib_color_initialize, MRB_ARGS_NONE());
    }
    EOS
  end
end

