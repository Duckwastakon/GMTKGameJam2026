shader_type spatial;

uniform vec3 albedo: source_color;
uniform float metallic: hint_range(0.0, 1.0) = 0;
uniform float roughness: hint_range(0.0, 1.0) = 0.02;
uniform sampler2D wave;
uniform sampler2D textureNormal1;
uniform sampler2D textureNormal2;
uniform vec2 waveDirection = vec2(2.0, 0.0);
uniform vec2 waveDirection2 = vec2(0.0, 1.0);
uniform float timeScale: hint_range(0.0, 0.2, 0.005) = 0.025;
uniform float noise_scale = 10.0;
uniform float height_scale = 0.15;

varying float height;
varying vec3 worldPos;

void fragment() {
	vec2 time = (TIME*waveDirection) * timeScale;
	vec2 time2 = (TIME*waveDirection2) * timeScale;
	vec3 normalBlend = mix(texture(textureNormal1, worldPos.xz + time).rgb, texture(textureNormal2, worldPos.xz + time2).rgb, 0.5);
	ALBEDO = albedo;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normalBlend;
}

void vertex(){
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	height = texture(wave, worldPos.xz / noise_scale + TIME * timeScale).r;
	VERTEX.y += height * height_scale;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
