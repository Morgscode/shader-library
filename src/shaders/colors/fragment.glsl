#define PI 3.14159265359

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

// render solid red
// void main() {
//     gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
// }

// render a gradient of black to white
// void main() {
//     gl_FragColor = vec4(vec3(v_uv.x), 1.0);
// }

// flip the gradient
// void main() {
//     gl_FragColor = vec4(vec3(1.0 - v_uv.x), 1.0);
// }

// render a colorful gradient
// void main() {
//     gl_FragColor = vec4(v_uv, 0.0, 1.0);
// }

// probably my favorite static gradient example
// void main() {
//     gl_FragColor = vec4(v_uv.y, 0.5, v_uv.x, 1.0);
// }

// get trippy with it
// void main() {
//     gl_FragColor = vec4(v_uv.y, abs(sin(u_time)), v_uv.x, 1.0);
// }

// animate to beats per minute
// void main() {
//     gl_FragColor = vec4(v_uv.x, sin(u_time * 13.0), v_uv.y, 1.0);
// }

// bpm progressive horizontal noise
// void main() {  
//     gl_FragColor = vec4(v_uv.x, sin(v_uv.y * u_time * 130.0), v_uv.y, 1.0);
// }

// dmt like
// void main() { 
//     vec2 uv = v_uv * 2.0 - 1.0;
//     uv.x *= u_resolution.x / u_resolution.y;
//     gl_FragColor = vec4(uv.x, sin(uv.x * uv.y * pow(u_time, PI) * 1.30), uv.y, 1.0);
// }

// cosine based palette
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.75, 0.75, 0.75);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.333, 0.667);

    return a + b * cos(6.283185 * (c * t + d));
}

// color pallette based animation
void main() { 
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    vec3 color = palette(length(uv) + (u_time * 1.30));
    gl_FragColor = vec4(color, 1.0);
}