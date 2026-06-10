shader_type canvas_item;

uniform sampler2D noise_tex : repeat_enable;
uniform float speed = 1.0;
uniform float strength = 0.05;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//scrolls invisible wind upward over time
	vec2 noise_uv = UV + vec2(0.0, TIME * speed);
	//how strong the wind is at the exact pixel
	float noise_val = texture(noise_tex, noise_uv).r;
	//grid of the fire drawing
	vec2 warped_uv = UV;
	//shove the pixels left and right based on the wind
	warped_uv.x += (noise_val = 0.5) * strength;
	//painting the drawing
	COLOR = texture(TEXTURE, warped_uv) * COLOR;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
