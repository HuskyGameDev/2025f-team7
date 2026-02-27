shader_type canvas_item;

uniform float step_rate: hint_range(0.0, 10.0) = 4.0;
uniform float distortion_strength: hint_range(1.0, 30.0) = 3.0;

uniform sampler2D shine_texture;

varying vec2 shine_uv;

void vertex() {
	float steps = floor(TIME * step_rate) / step_rate;
	VERTEX.x += cos((steps * 20.0) + VERTEX.x + VERTEX.y) * distortion_strength;
	VERTEX.y += cos((steps * 20.0) + VERTEX.x + VERTEX.y) * distortion_strength;
	
	// center of the node in world coodinates
	vec2 node_position = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xy;
	// vertex position in world coordinates
	vec2 position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	
	// genuinely i am not quite sure how this works
	// loosely based on this:
	// https://forum.godotengine.org/t/access-viewport-transform-scale-in-shader-code/87213
	vec2 scale = vec2(length(MODEL_MATRIX[0]), length(MODEL_MATRIX[1]));
	
	shine_uv = position - node_position;
	shine_uv *= TEXTURE_PIXEL_SIZE / scale;
	
	// this bit shrinks the UV to either the left or right
	// half depending on the time value
	shine_uv += vec2(0.5, 0.5);
	shine_uv.x /= 2.0;
	if (int((TIME * step_rate)) % 2 == 0) {
		shine_uv.x += 0.5;
	}
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 shine = texture(shine_texture, shine_uv);
	
	COLOR = vec4(color.rgb + shine.aaa / 4.0, color.a); // vec4(color.rgb + shine.aaa / 4.0, color.a);
}