class Function
  attr_reader :c_name, :ruby_name, :arguments

  def initialize(src)
    @c_name = "CloseWindow"
    @ruby_name = "close_window"
    @arguments = []
  end

  def ret_type
    "void"
  end
end