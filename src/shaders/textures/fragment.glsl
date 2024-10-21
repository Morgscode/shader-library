varying vec2 v_uv;
uniform sampler2D u_diffuse;
uniform vec4 u_tint;

// render an image 
// void main() {
//     gl_FragColor = texture2D(u_diffuse, v_uv);
// }

// flip the image
// void main() {
//     gl_FragColor = texture2D(u_diffuse, vec2(1.0 - v_uv.x, 1.0 - v_uv.y));
// }

// tint the image using "modulation" 
void main() {
    vec4 diffuse_sample = texture2D(u_diffuse, v_uv);
    gl_FragColor = diffuse_sample * u_tint;
}
