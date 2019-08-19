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
    "mrb_define_module_function(mrb, mod_raylib, \"#{ruby_name}\", mrb_raylib_#{ruby_name}, MRB_ARGS_REQ(#{arguments.count}));"
  end

  def impl_content
    <<-EOS
static mrb_value
mrb_init_window(mrb_state *mrb, mrb_value self)
{
    mrb_int width, height = 0;
    mrb_value title;
    mrb_get_args(mrb, "iiS", &width, &height, &title);

    InitWindow(width, height, RSTRING_PTR(title));

    return self;
}
    EOS
  end
end