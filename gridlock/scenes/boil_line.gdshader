shader_type canvas_item;

uniform float step_rate: hint_range(0.0, 10.0) = 4.0;
uniform float distortion_strength: hint_range(1.0, 30.0) = 3.0;

void vertex() {
  float steps = floor(fract(TIME) * step_rate) / step_rate;
  VERTEX.x += cos((steps * 20.0) + VERTEX.x + VERTEX.y) * distortion_strength;
  VERTEX.y += cos((steps * 20.0) + VERTEX.x + VERTEX.y) * distortion_strength;
}