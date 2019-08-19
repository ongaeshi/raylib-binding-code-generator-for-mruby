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
    'mrb_define_module_function(mrb, mod_raylib, "init_window", mrb_raylib_init_window, MRB_ARGS_REQ(3));'
  end
end