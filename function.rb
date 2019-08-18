class Function
  attr_reader :c_name, :ruby_name
  attr_reader :ret_type
  attr_reader :arguments

  def initialize(src)
    ret_type, c_name, arguments = src.scan(/([\w ]+?)(\w+)\((.*)\)/)[0]

    @c_name = c_name
    @ruby_name = "close_window"
    @ret_type = parse_ret_type(ret_type)
    @arguments = parse_arguments(arguments)
  end

  def parse_ret_type(ret_type)
    ret_type.strip
  end

  def parse_arguments(arguments)
    arguments = arguments.strip
    
    return [] if (arguments == "void")
    
    raise
  end
end