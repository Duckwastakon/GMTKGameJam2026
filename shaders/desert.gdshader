shader_type spatial;
render_mode cull_disabled, unshaded, blend_mix, depth_draw_never;

uniform vec4 smoke_color : source_color = vec4(0.6, 0.6, 0.6, 1.0);
uniform float clear_radius = 5.0;
uniform float fade_distance = 10.0;
uniform sampler2D noise_tex;
uniform float scroll_speed = 0.03;
uniform float noise_scale = 2.0;

void fragment() {
	float dist = length(VERTEX);
	float alpha = smoothstep(clear_radius, clear_radius + fade_distance, dist);

	vvec2 uv1 = UV * noise_scale + vec2(TIME * scroll_speed, -TIME * scroll_speed * 1.2);
	vec2 uv2 = UV * noise_scale * 1.7 - vec2(TIME * scroll_speed * 0.5, TIME * scroll_speed * 0.3);
	float noise1 = texture(noise_tex, uv1).r;
	float noise2 = texture(noise_tex, uv2).r;
	float combined_noise = mix(noise1, noise2, 0.5);

	float fresnel = pow(1.0 - abs(dot(NORMAL, VIEW)), 2.0);

	ALBEDO = smoke_color.rgb * mix(0.85, 1.15, combined_noise);
	ALPHA = clamp(alpha * mix(0.4, 1.0, combined_noise) + fresnel * 0.3, 0.0, 1.0);
}