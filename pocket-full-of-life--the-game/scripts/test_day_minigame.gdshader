shader_type canvas_item;

uniform sampler2D noise_tex : repeat_enable;
uniform float speed = 0.5; //speed
uniform float intensity = 0.5; //how dark the ripples get

void fragment() {
	//scroll the invisible noise straight down
	vec2 scroll_uv = UV + vec2(0.0, -TIME * speed);
	float noise_val = texture(noise_tex, scroll_uv).r;
	
	//grtabs original drawing of the light
	vec4 original_light = texture(TEXTURE, UV);
	
	//multiplies light opacity by ripple above
	original_light.a *= mix(1.0 - intensity, 1.0, noise_val);
	
	//paints it
	COLOR = original_light;
}