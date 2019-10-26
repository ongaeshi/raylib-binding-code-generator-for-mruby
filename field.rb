require_relative 'util'

class Field
  attr_reader :type, :name

  def initialize(src)
    type, name = src.scan(/([\w *]+) (\w+);?\Z/)[0]
    @type = type.strip
    @name = name.strip
  end

  def impl_header(declare_type)
    <<-EOS
static mrb_value 
mrb_raylib_#{declare_type.lower_name}_#{name}(mrb_state *mrb, mrb_value self)
{
    #{declare_type.name} *obj = DATA_PTR(self);
    return #{to_mrb_value("obj->#{name}")};
}

static mrb_value 
mrb_raylib_#{declare_type.lower_name}_set_#{name}(mrb_state *mrb, mrb_value self)
{
    #{to_mrb_type} value;
    mrb_get_args(mrb, "#{get_args_parameter}", &value);

    #{declare_type.name} *obj = DATA_PTR(self);
    obj->#{name} = #{setter_value};

    return #{setter_return};
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

  def get_args_parameter
    case type
    when "int", "unsigned char", "unsigned int"
      "i"
    when "float"
      "f"
    when "bool"
      "b"
    when "const char*"
      "S"
    when *raylib_objects
      "o"
    when *raylib_objects_ptr
      "o"
    else
      raise type
    end
  end

  def to_mrb_type
    case type
    when "int", "unsigned char", "unsigned int"
      "mrb_int"
    when "float"
      "mrb_float"
    when "bool"
      "mrb_bool"
    when "const char*"
      "mrb_value"
    when *raylib_objects
      "mrb_value"
    when *raylib_objects_ptr
      "mrb_value"
    else
      raise type
    end
  end

  def to_c_argument
    case type
    when "int", "unsigned char", "unsigned int"
      name
    when "float"
      name
    when "bool"
      name
    when "const char*"
      "RSTRING_PTR(#{name})"
    when *raylib_objects
      "*(#{type}*)DATA_PTR(#{name})"
    when *raylib_objects_ptr
      "(#{type})DATA_PTR(#{name})"
    else
      raise type
    end
  end

  def to_mrb_value(value)
    case type
    when "int", "unsigned char", "unsigned int"
      "mrb_fixnum_value(#{value})"
    when "float"
      "mrb_float_value(mrb, #{value})"
    when "bool"
      "mrb_bool_value(#{value})"
    when *raylib_objects
      "mrb_raylib_#{type.downcase}_to_mrb(mrb, #{value})"
    else
      raise type
    end
  end

  def setter_value
    case type
    when *raylib_objects
      "*(#{type}*)DATA_PTR(value)"
    else
      "value"
    end
  end

  def setter_return
    case type
    when *raylib_objects
      "value"
    else
      to_mrb_value("value")
    end
  end
end