class Field
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end
end