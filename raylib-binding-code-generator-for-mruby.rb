require 'yaml'
require_relative 'parser'

if $0 == __FILE__
  parser = Parser.new(<<-EOS
  - name: struct Color
    field:
    - unsigned char r;
    - unsigned char g;
    - unsigned char b;
    - unsigned char a;
  - name: struct Vector2
  - name: struct Vector3
  - name: struct Camera
  EOS
  )

  puts parser.impl_content
end
