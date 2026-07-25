shader_type spatial;

uniform float height = 64.0;
uniform sampler2D color_gradient;
uniform sampler2D normal_map;

void fragment() {
	vec4 worldVertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 modelVertex = (inverse(MODEL_MATRIX) * worldVertex).xyz;
	float gradientUv = (modelVertex.y/height) + 0.5;
	
	ALBEDO = texture(color_gradient, vec2(gradientUv)).rgb;
	NORMAL_MAP = texture(normal_map, UV).xyz;
}
