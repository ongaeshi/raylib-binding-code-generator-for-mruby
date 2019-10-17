require_relative 'field'

class Type
  attr_reader :name, :lower_name
  attr_reader :fields

  def initialize(name, fields)
    @name = name
    @lower_name = name.downcase
    @fields = (fields || []).map do |e|
      parse_field(e)
    end
  end

  def parse_field(src)
    Field.new(src)
  end

  def impl_header
    <<-EOS
static struct RClass *mrb_cls_raylib_#{lower_name};
const static struct mrb_data_type mrb_raylib_#{lower_name}_data_type = { "#{name}", mrb_free };

static mrb_value
mrb_raylib_#{lower_name}_to_mrb(mrb_state *mrb, #{name} src)
{
    #{name} *obj = (#{name}*)mrb_malloc(mrb, sizeof(#{name}));
    *obj = src;

    struct RData *data = mrb_data_object_alloc(
        mrb,
        mrb_cls_raylib_#{lower_name},
        obj,
        &mrb_raylib_#{lower_name}_data_type
        );

    return mrb_obj_value(data);
}

static mrb_value
mrb_raylib_#{lower_name}_initialize(mrb_state *mrb, mrb_value self)
{
    #{name} *obj;

    obj = (#{name}*)mrb_malloc(mrb, sizeof(#{name}));
    memset(obj, 0, sizeof(#{name}));

    DATA_TYPE(self) = &mrb_raylib_#{lower_name}_data_type;
    DATA_PTR(self) = obj;
    return self;
}

#{@fields.map { |e| e.impl_header(self) }.join("\n")}
    EOS
  end

  def impl_content
    <<-EOS
    {
        struct RClass *cls = mrb_define_class_under(mrb, mod_raylib, "#{name}", mrb->object_class);
        mrb_cls_raylib_#{lower_name} = cls;
        MRB_SET_INSTANCE_TT(cls, MRB_TT_DATA);
        mrb_define_method(mrb, cls, "initialize", mrb_raylib_#{lower_name}_initialize, MRB_ARGS_NONE());
#{@fields.map { |e| e.impl_content(self) }.join("\n")}
    }
    EOS
  end
end
