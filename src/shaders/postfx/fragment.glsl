varying vec2 v_uv;

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texturemap;
uniform vec3 u_tint;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

vec3 saturate(vec3 x) {
    return clamp(x, vec3(0.0), vec3(1.0));
}

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

// basic color manipulation
void main() {
    vec2 v_uv2x = fract(v_uv * vec2(2.0, 1.0));
    v_uv2x.x = remap(v_uv2x.x, 0.0, 1.0, 0.25, 0.75);
    vec3 color = texture2D(u_texturemap, v_uv2x).xyz;

    if (v_uv.x > 0.5) {
        // tinting
        color *= (u_tint / 2.0);
        // brightness
        color += 0.25;
        // saturation
        float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
        float sat = 0.0;
        color = mix(vec3(luminance), color, sat);
        // contrast
        float contrast = 10.0;
        float midpoint = 0.5;
        color = (color - midpoint) * contrast * midpoint;
        // color grading
        color = pow(color, vec3(1.5, 0.8, 1.5));
    }   

    gl_FragColor = vec4(color, 1.0);
}

