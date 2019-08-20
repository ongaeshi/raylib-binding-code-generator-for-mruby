module Caseninja
  module_function

  def to_hash(text)
    {
      chain: to_chain(text),
      snake: to_snake(text),
      camel: to_camel(text),
      pascal: to_pascal(text),
      upchain: to_upchain(text),
      upsnake: to_upsnake(text),
    }
  end

  def to_chain(text)
    normalize(text).gsub(" ", "-")
  end

  def to_snake(text)
    normalize(text).gsub(" ", "_")
  end

  def to_camel(text)
    to_pascal(text).sub(/./) { $&.downcase }
  end

  def to_pascal(text)
    normalize(text).split.map { |e| e.capitalize }.join
  end

  def to_upchain(text)
    to_chain(text).upcase
  end
  
  def to_upsnake(text)
    to_snake(text).upcase
  end

  def normalize(text)
    if text =~ / /
      text.downcase
    elsif text =~ /-/
      text.gsub("-", " ").downcase
    elsif text =~ /_/
      text.gsub("_", " ").downcase
    else
      text.gsub(/([a-z])([A-Z])/, "\\1 \\2").downcase
    end
  end
  
end
