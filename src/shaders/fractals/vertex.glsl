varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    v_uv = uv;
}