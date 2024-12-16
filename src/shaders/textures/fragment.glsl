uniform float u_time;
uniform sampler2D u_texturemap;
uniform vec4 u_tint;

varying vec2 v_uv;

// render an image 
// void main() {
//     gl_FragColor = texture2D(u_texturemap, v_uv);
// }

// flip the image 
// void main() {
//     gl_FragColor = texture2D(u_texturemap, vec2(1.0 - v_uv.x, 1.0 - v_uv.y));
// }

// tint the image using "modulation" 
// void main() {
//     vec4 diffuse_sample = texture2D(u_texturemap, vec2(1.0 - v_uv.x, 1.0 - v_uv.y));
//     gl_FragColor = diffuse_sample * u_tint;
// }

// blend texture with color and variations
// void main() {
//     vec4 diffuse_sample = texture2D(u_texturemap, vec2(1.0 - v_uv.x, 1.0 - v_uv.y));
//     gl_FragColor = diffuse_sample * vec4(v_uv.x, abs(sin(u_time * 130.0)), v_uv.y, 1.0);
// }

// addressing with clamp to edge 
// void main() {
//     vec2 uv_x2 = v_uv * 2.0;
//     gl_FragColor = texture2D(u_texturemap, uv_x2);
// }

// addressing with repeat
// void main() {
//     vec2 uv_x2 = mod(v_uv * 2.0, 1.0);
//     gl_FragColor = texture2D(u_texturemap, uv_x2);
// }

// addressing with mirrored repeat wrapping
// void main() {
//     vec2 uv_x2 = abs(mod(v_uv * 2.0, 2.0) - 1.0);
//     gl_FragColor = texture2D(u_texturemap, uv_x2);
// }

// zoom in/out repeating effect 
// void main() {
//     vec2 uv = mod((v_uv - 0.5) * abs(sin(u_time)) + 0.5, 1.0);
//     gl_FragColor = texture2D(u_texturemap, uv);
// }

// mixed wrappping, zoom effects, blend and texture flips
void main() {
    vec2 uv = mod((v_uv - 0.5) * sin(u_time / 5.0) + 0.5, 1.0);
    gl_FragColor = texture2D(u_texturemap, uv) * vec4(v_uv.x, abs(sin(u_time)), v_uv.y, 1.0);
}

// bpm mixed effects 
// void main() {
//     vec2 uv = mod((v_uv - 0.5) * sin(u_time * 130.0) + 0.5, 2.0);
//     gl_FragColor = texture2D(u_texturemap, uv) * vec4(v_uv.x, sin(u_time * 130.0), v_uv.y, 1.0);
// }

// gradual noise over texture
// void main() {
//     vec3 color = vec3(0.5);
    
//     vec4 diffuse_sample = texture2D(u_texturemap, v_uv);
//     float t = sin(v_uv.y * 500.0);
//     color = cos(vec3(t) * sin(u_time * v_uv.y));
   
//     gl_FragColor = vec4(color, 1.0) * diffuse_sample;
// }
