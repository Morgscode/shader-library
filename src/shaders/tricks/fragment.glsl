uniform float u_time;

varying vec2 v_uv;

// step changes
// void main() {
//     gl_FragColor = vec4(vec3(step(0.5,v_uv.x), v_uv), 1.0);
// }

// mix 
void main() {
    gl_FragColor = vec4(vec3(mix(v_uv.x, v_uv.y, 1.0)), 1.0);
}