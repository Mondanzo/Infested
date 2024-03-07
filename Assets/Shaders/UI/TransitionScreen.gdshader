shader_type canvas_item;

uniform float progress: hint_range(0, 2, 0.01);
uniform float angle: hint_range(0, 360, 0.1);
uniform int frags = 10;

float determine_offset(float current_progress, float offset){
	return 1.0;
}


void fragment(){
	float rot = radians(angle);
	mat2 rotation_matrix = mat2(vec2(cos(rot), -sin(rot)), vec2(sin(rot), -cos(rot)));
	vec2 uv_rotated = UV.xy * rotation_matrix;
	vec2 loc = fract(uv_rotated * float(frags));
	vec2 cell_index = floor(uv_rotated * float(frags)) / float(frags);
	float cell_progress = (cell_index.x - cell_index.y) * 0.5;
	float loc_progress = (loc.x + (1.0 - loc.y)) * 0.5;

//	COLOR.bg = loc_modified;
	
	loc_progress *= 0.3;
	loc_progress += cell_progress * 0.7;
//	COLOR.r = cell_progress;
//	loc_progress = cell_progress;
	if(progress <= 1.0){
		if(loc_progress >= progress){
			discard;
		}
	} else {
		if(loc_progress <= (progress - 1.0)){
			discard;
		}
	}
}