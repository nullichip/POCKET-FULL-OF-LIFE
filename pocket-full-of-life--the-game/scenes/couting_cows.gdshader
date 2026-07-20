shader_type canvas_item;

uniform sampler2D cloud_texture : repeat_enable;
uniform vec2 wind_speed = vec2(0.02, 0.01);

// NEW: Add a color picker for the glow in the Inspector!
uniform vec4 glow_color : source_color = vec4(0.6, 0.8, 1.0, 1.0); // Defaults to pale blue
uniform float glow_intensity = 1.2; // How bright the glow is

void fragment() {
	vec2 moving_uv = UV + (TIME * wind_speed);
	vec4 noise = texture(cloud_texture, moving_uv);

	// 1. Get the shape of the cloud
	float cloud_alpha = noise.r * COLOR.a;

	// 2. Mix your dark shadow color with the bright moonlight color
	// The noise.r makes it so the center of the clouds glow the most!
	vec3 final_color = mix(COLOR.rgb, glow_color.rgb, noise.r * 0.5);

	// 3. Multiply it by the intensity to make it pop
	final_color = final_color * glow_intensity;

	// 4. Output the final glowing cloud
	COLOR = vec4(final_color, cloud_alpha);
}