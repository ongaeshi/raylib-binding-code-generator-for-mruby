require_relative "caseninja"

class Function
  attr_reader :c_name, :ruby_name
  attr_reader :ret_type
  attr_reader :arguments

  def initialize(src)
    ret_type, c_name, arguments = src.scan(/([\w ]+?)(\w+)\((.*)\)/)[0]

    @c_name = c_name
    @ruby_name = Caseninja.to_snake(c_name)
    @ret_type = parse_ret_type(ret_type)
    @arguments = parse_arguments(arguments)
  end

  def parse_ret_type(ret_type)
    ret_type.strip
  end

  def parse_arguments(arguments)
    arguments = arguments.strip

    return [] if (arguments == "void")

    arguments.split(",").map do |e|
      Field.new(e)
    end
  end

  def impl_header
    <<-EOS
static mrb_value
mrb_raylib_#{ruby_name}(mrb_state *mrb, mrb_value self)
{
#{get_args}

#{call_function}

#{return_value}
}
    EOS
  end

  def get_args
    return "" if (arguments.count == 0)

    <<-EOS.chomp
#{arguments.map { |e| "    #{e.to_mrb_type} #{e.name};" }.join("\n")}
    mrb_get_args(mrb, "#{arguments.map { |e| e.get_args_parameter }.join("") }", #{arguments.map { |e| "&#{e.name}" }.join(", ") });
    EOS
  end

  def call_function
    c = "#{c_name}(#{arguments.map { |e| e.to_c_argument }.join(", ")})"

    case ret_type
    when "void"
      "    #{c};"
    when "bool"
      "    mrb_bool ret = mrb_bool_value(#{c});"
    else
      raise ret_type
    end
  end

  def return_value
    if ret_type == "void"
      "    return self;"
    else
      "    return ret;"
    end
  end

  def impl_content
    "    mrb_define_module_function(mrb, mod_raylib, \"#{ruby_name}\", mrb_raylib_#{ruby_name}, #{mrb_args});"
  end

  def mrb_args
    if arguments.count == 0
      "MRB_ARGS_NONE()"
    else
      "MRB_ARGS_REQ(#{arguments.count})"
    end
  end
end