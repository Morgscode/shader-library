// all uniforms and attributes are supplied by THREE.JS
// https://threejs.org/docs/#api/en/materials/ShaderMaterial

varying vec2 v_uv;

void main() {
    vec4 localPosition = vec4(position, 1.0);
    gl_Position = projectionMatrix * modelViewMatrix * localPosition;
    v_uv = uv;
}
