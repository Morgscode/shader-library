varying vec2 v_uv;

// ambient lighting
void main() {
    vec3 base = vec3(0.0);
    vec3 lighting = vec3(0.0);
    vec3 ambient(0.5);
    lighting = ambient;
    vec3 color = base * lighting;
    gl_FragColor = vec4(color, 1.0);
}

// hemisphere lighting
// void main() {
//     vec3 color = vec3(0.0);
//     gl_FragColor = vec4(color, 1.0);
// }

