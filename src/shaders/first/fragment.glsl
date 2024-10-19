uniform float u_time;

varying vec2 v_uv;

void main() {
    gl_FragColor = vec4(v_uv.y, abs(u_time), v_uv.x, 1.0);
}
