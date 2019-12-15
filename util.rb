RAYLIB_OBJECTS = %w(
  Vector2
  Vector3
  Vector4
  Matrix
  Color
  Rectangle
  Image
  Texture2D
  Camera2D
  Camera3D
  Font
  RenderTexture2D
  NPatchInfo
  CharInfo
  Mesh
  Shader
  MaterialMap
  Material
  Model
  Transform
  BoneInfo
  ModelAnimation
  Ray
  RayHitInfo
  BoundingBox
  Wave
  Sound
  Music
  AudioStream
  VrDeviceInfo
)

def raylib_objects
  RAYLIB_OBJECTS
end

def raylib_objects_ptr
  RAYLIB_OBJECTS.map { |e| e + "*" }
end
