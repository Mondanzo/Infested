shader_type canvas_item;

uniform float strength;
uniform float spread = 0.2;

void fragment() {
	vec2 uv = UV - 0.5;
	float radius = length(uv);
	COLOR.a = smoothstep(strength, strength + spread, radius);
}
