uniform float u_time;

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
//     gl_FragColor = vec4(v_uv.x, abs(tan(u_time * 130.0)), v_uv.y, 1.0);
// }

// dmt like
// void main() { 
//     gl_FragColor = vec4(v_uv.x, abs(tan(v_uv.y * v_uv.x * u_time * 130.0)), v_uv.y, 1.0);
// }

// bpm progressive horizontal noise
void main() {  
    gl_FragColor = vec4(v_uv.x, abs(sin(v_uv.y + v_uv.y * u_time * 130.0)), v_uv.y, 1.0);
}
