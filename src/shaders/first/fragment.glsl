varying vec2 v_uv;

void main() {
    gl_FragColor = vec4(v_uv.y, 0.0, v_uv.x, 1.0);
}
