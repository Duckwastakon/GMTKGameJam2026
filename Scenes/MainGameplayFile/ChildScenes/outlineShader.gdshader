shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform vec4 outlineColor: source_color;
uniform float outlineWidth = 2.0;

void fragment() {
	vec4 pixelatedTexture = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixelSize = 1.0 / VIEWPORT_SIZE;
	ALBEDO = pixelatedTexture.rgb;
	
	for(int y = -1*int(outlineWidth); y<= 1*int(outlineWidth); y++)
	for(int x = -1*int(outlineWidth); x<= 1*int(outlineWidth); x++){
		vec4 tex =  texture(SCREEN_TEXTURE, SCREEN_UV + vec2(float(x), float(y)) * pixelSize);
		if(tex.a==0.0 && 
		SCREEN_UV.x * float(x) * pixelSize.x < 1.0 &&
		SCREEN_UV.x * float(x) * pixelSize.x > 0.0 &&
		SCREEN_UV.y * float(y) * pixelSize.y < 1.0 &&
		SCREEN_UV.y * float(y) * pixelSize.y > 0.0){
			ALBEDO = outlineColor.rgb;
			ALPHA= 1.0;
		}
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
