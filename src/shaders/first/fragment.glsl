varying vec2 uvCords;

void main() {
    gl_FragColor = vec4(uvCords.y, 0.0, uvCords.x, 1.0);
}
