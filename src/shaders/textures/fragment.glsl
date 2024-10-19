varying vec2 v_uv;
uniform sampler2D u_diffuse;

void main() {
    gl_FragColor = texture2D(u_diffuse, v_uv);
}