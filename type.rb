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
    type, name = src.scan(/([\w ]+) (\w+);/)[0]
    Field.new(type, name)
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

#{@fields.map { |e| e.impl_header(self) }.join("\n")}
    EOS
  end

  def impl_content
    <<-EOS
    {
        struct RClass *cls = mrb_define_class_under(mrb, mod_raylib, "#{name}", mrb->object_class);
        MRB_SET_INSTANCE_TT(cls, MRB_TT_DATA);
        mrb_define_method(mrb, cls, "initialize", mrb_raylib_#{lower_name}_initialize, MRB_ARGS_NONE());
#{@fields.map { |e| e.impl_content(lower_name) }.join("\n")}
    }
    EOS
  end
end
