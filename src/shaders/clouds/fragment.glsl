varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

float opUnion(float d1, float d2) {
  return min(d1, d2);
}

float opSubtraction(float d1, float d2) {
  return max(-d1, d2);
}

float opIntersection(float d1, float d2) {
  return max(d1, d2);
}

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

mat2 rotate2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(
        c, -s, 
        s, c
    );
}

vec3 draw_bg() {
    return mix(
        vec3(0.4, 0.5, 0.75),
        vec3(0.3, 0.4, 0.8),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );
}

void main() {
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    vec3 color = draw_bg();

    float cloud = sdCircle(pixel_coords, 100.0);
    float shadow = sdCircle(pixel_coords + vec2(50.0), 120.0);

    color = mix(color, vec3(0.0), 0.5 * smoothstep(0.0, -100.0, shadow));
    color = mix(vec3(1.0), color, smoothstep(0.0, 1.0, cloud));

    gl_FragColor = vec4(color, 1.0);
}