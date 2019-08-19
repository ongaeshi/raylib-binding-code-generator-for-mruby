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
mrb_raylib_#{ruby_name}(mrb_state *mrb, mrb_value self)
{
#{get_args}

#{call_function}

#{return_value}
}
    EOS
  end

  def get_args
    <<-EOS.chomp
#{arguments.map { |e| "    #{e.to_mrb_type} #{e.name};" }.join("\n")}
    mrb_get_args(mrb, "#{arguments.map { |e| e.get_args_parameter }.join("") }", #{arguments.map { |e| "&#{e.name}" }.join(", ") });
    EOS
  end

  def call_function
    <<-EOS.chomp
    #{c_name}(width, height, RSTRING_PTR(title));
    EOS
  end

  def return_value
    <<-EOS.chomp
    return self;
    EOS
  end
end