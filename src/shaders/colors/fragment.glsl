#define PI 3.1415926535

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

// render solid red
void main() {
    gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
}

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