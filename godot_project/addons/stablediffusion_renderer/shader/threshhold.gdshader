shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 resolution = vec2(384, 216);



void vertex() {
	POSITION = vec4(VERTEX.xyz, 1.0);
	//POSITION = vec4(0.0, 0.0, 0.0, 1.0);
}

//shader_type canvas_item;


void fragment() {
	
	//ALBEDO = col;
	
	vec4 col = texture(screen_texture, SCREEN_UV);
	float cMax = max(max(col.r, col.g), col.b);
	float cMin = min(min(col.r, col.g), col.b);
	
	if (((cMax + cMin) / 2.0) < 0.5) ALBEDO = vec3(0.0);
	else ALBEDO = vec3(1.0);
}
