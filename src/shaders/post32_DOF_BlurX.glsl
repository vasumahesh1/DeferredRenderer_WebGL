#version 300 es
precision highp float;

in vec2 fs_UV;
out vec4 out_Col;

uniform ivec2 u_Dimensions;
uniform sampler2D u_frame;

const float weight[7] = float[] (0.00598, 0.060626, 0.241843, 0.383103, 0.241843, 0.060626, 0.00598);

void main() {
  vec4 baseColor = texture(u_frame, fs_UV);
  
  float posX = 1.0 / (float(u_Dimensions.x) - 1.0);
  float posY = 1.0 / (float(u_Dimensions.y) - 1.0);

  vec2 tex_offset = vec2(posX, posY); // gets size of single texel
  vec3 result = baseColor.rgb * weight[0]; // current fragment's contribution

  for(int i = 1; i < 7; ++i)
  {
      result += texture(u_frame, fs_UV + vec2(tex_offset.x * float(i), 0.0)).rgb * weight[i];
      result += texture(u_frame, fs_UV - vec2(tex_offset.x * float(i), 0.0)).rgb * weight[i];
  }

  out_Col = vec4(result, baseColor.a);
}