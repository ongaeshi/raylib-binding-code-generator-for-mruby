class Field
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end

  def impl_header(declare_type)
    <<-EOS
static mrb_value 
mrb_raylib_#{declare_type.lower_name}_#{name}(mrb_state *mrb, mrb_value self)
{
    #{declare_type.name} *obj = DATA_PTR(self);
    return mrb_fixnum_value(obj->#{name});
}

static mrb_value 
mrb_raylib_#{declare_type.lower_name}_set_#{name}(mrb_state *mrb, mrb_value self)
{
    mrb_int value;
    mrb_get_args(mrb, "i", &value);

    #{declare_type.name} *obj = DATA_PTR(self);
    obj->#{name} = value;

    return mrb_fixnum_value(value);
}
    EOS
  end

  def impl_content(declare_type)
    s = <<-EOS
        mrb_define_method(mrb, cls, \"#{name}\", mrb_raylib_#{declare_type.lower_name}_#{name}, MRB_ARGS_NONE());
        mrb_define_method(mrb, cls, \"#{name}=\", mrb_raylib_#{declare_type.lower_name}_set_#{name}, MRB_ARGS_REQ(1));
    EOS

    s.chomp
  end
end