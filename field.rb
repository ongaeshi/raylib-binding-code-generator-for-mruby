class Field
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end

  def impl_header
    ""
  end

  def impl_content(declare_type)
    s = <<-EOS
        mrb_define_method(mrb, cls, \"#{name}\", mrb_raylib_#{declare_type}_#{name}, MRB_ARGS_NONE());
        mrb_define_method(mrb, cls, \"#{name}=\", mrb_raylib_#{declare_type}_set_#{name}, MRB_ARGS_REQ(1));
    EOS

    s.chomp
  end
end