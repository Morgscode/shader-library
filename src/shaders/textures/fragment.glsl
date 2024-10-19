varying vec2 uvCords;

uniform sampler2D diffuse;

void main() {
    gl_FragColor = texture2D(diffuse, uvCords);
}