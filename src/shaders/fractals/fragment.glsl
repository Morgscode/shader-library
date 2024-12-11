varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

// base fractal
void main() {
    //  center our uvs
    float angle = u_time * 0.3;
    vec2 uv = v_uv * 2.0 - 1.0;
    // make it responsive to the current screen size
    uv.x *= u_resolution.x / u_resolution.y;
    // start the fractal process
    for (float i = 0.0; i < 32.0; i += 1.0) {
        uv = abs(uv);
        uv -= 0.5;
        uv *= 1.1;
        uv *= mat2(
            cos(angle), -sin(angle),
            sin(angle), cos(angle)
        );    
    }
    // render the final color
    gl_FragColor = vec4(vec3(length(uv)), 1.0);
}
