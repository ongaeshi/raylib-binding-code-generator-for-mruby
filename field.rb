class Field
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end

  def impl_header
    ""
  end

  def impl_content
    ""
  end
end