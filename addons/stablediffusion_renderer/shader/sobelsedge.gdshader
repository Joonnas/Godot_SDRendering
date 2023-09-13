shader_type spatial;

uniform sampler2D depth_texture : source_color, hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 resolution = vec2(384, 216);



void vertex() {
	POSITION = vec4(VERTEX.xyz, 1.0);
	//POSITION = vec4(0.0, 0.0, 0.0, 1.0);
}

//shader_type canvas_item;


void fragment() {
	
	vec2 SCREEN_PIXEL_SIZE = 1.0 / VIEWPORT_SIZE;
	
	vec3 col = vec3(0.5);
	col += texture(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz * -1.0;
	col += texture(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, 0.0)).xyz * -2.0;
	col += texture(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz * -1.0;
	
	col += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz * 1.0;
	col += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0.0)).xyz * 2.0;
	col += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz * 1.0;
	
	
	col += texture(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz * -1.0;
	col += texture(screen_texture, SCREEN_UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y)).xyz * -2.0;
	col += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, -SCREEN_PIXEL_SIZE.y)).xyz * -1.0;
	
	col += texture(screen_texture, SCREEN_UV + vec2(-SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz * 1.0;
	col += texture(screen_texture, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y)).xyz * 2.0;
	col += texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y)).xyz * 1.0;
	
	col = vec3((col.x + col.y + col.z) / 3.0);
	
	//ALBEDO = col;
	
	if (col.x > 0.48 && col.x < 0.52) ALBEDO = vec3(1.0);
	else ALBEDO = vec3(0.0);
}
