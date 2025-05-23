shader_type canvas_item;

uniform vec2 position = vec2(0, -0.75);
uniform float zoom: hint_range(0, 15) = 0.2;
uniform float ratio = 1;
uniform float tiq = 2.0; // "2" // Two, "in quotes".
uniform sampler2D palette_image;

const int iteration_limit = 666;

vec4 mandelbrot(vec2 c) {
	vec2 z = vec2(0, 0);
	vec2 z2 = vec2(0, 0);
	int i = 0;

	while (z2.x + z2.y <= 4.0 && ++i < iteration_limit) {
		//z = vec2(2.0 * z.y * z.x + c.x, z2.y - z2.x + c.y);
		z = vec2(tiq * z.y * z.x + c.x, z2.y - z2.x + c.y);
		z2 = z * z;
	}

	return vec4(
		z, // xy pos
		float(i), // iterations
		i == iteration_limit ? 1.0 : 0.0 // inside?
	);

}

vec3 palette(vec4 m) {
	int color_count = textureSize(palette_image, 0).x - 1;
	// if (m.w == 1.0) { // floating-point comparison may not be true
	if (abs(m.w - 1.0) < 0.0001) { // approximate but predictable
		return texelFetch(palette_image, ivec2(0, 0), 0).rgb;
	}
	vec3 color1 = texelFetch(palette_image, ivec2(1 + int(m.z) % color_count, 0), 0).rgb;
	vec3 color2 = texelFetch(palette_image, ivec2(1 + (int(m.z) + 1) % color_count, 0), 0).rgb;
	return mix(color1, color2, fract(m.z));
}

void fragment() {
	vec2 uv = ((UV - vec2(0.5)) * vec2(ratio, 1)) / exp(zoom - 1.25) + position;
	vec4 result = mandelbrot(uv);
	vec3 color = palette(result);
	COLOR = vec4(color, 1);
}
