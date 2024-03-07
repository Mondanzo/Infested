shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;

uniform float alpha: hint_range(0.0, 1.0, 0.1);
uniform vec3 color: source_color;

void fragment() {
	ALPHA = alpha;
	ALBEDO = color;
}
