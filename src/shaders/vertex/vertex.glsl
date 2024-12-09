varying vec3 v_normal; 
varying vec3 v_position;

uniform float u_time;

void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
    v_position = (modelMatrix * vec4(position, 1.0)).xyz;
}