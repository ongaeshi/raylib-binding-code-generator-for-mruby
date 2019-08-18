class Type
  attr_reader :name, :lower_name

  def initialize(name)
    @name = name
    @lower_name = name.downcase
  end

  def impl_header
    <<-EOS
const static struct mrb_data_type mrb_raylib_#{lower_name}_type = { "#{name}", mrb_free };

static mrb_value
mrb_raylib_#{lower_name}_initialize(mrb_state *mrb, mrb_value self)
{
    #{name} *obj;

    obj = (#{name}*)mrb_malloc(mrb, sizeof(#{name}));
    memset(obj, 0, sizeof(#{name}));

    DATA_TYPE(self) = &mrb_raylib_#{lower_name}_type;
    DATA_PTR(self) = obj;
    return self;
}
    EOS
  end

  def impl_content
    <<-EOS
    {
        struct RClass *cls = mrb_define_class_under(mrb, mod_raylib, "#{name}", mrb->object_class);
        MRB_SET_INSTANCE_TT(cls, MRB_TT_DATA);
        mrb_define_method(mrb, cls, "initialize", mrb_raylib_#{lower_name}_initialize, MRB_ARGS_NONE());
    }
    EOS
  end
end

