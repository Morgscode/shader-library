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

vec3 bg_color() {
    float dist = length(abs(v_uv - 0.5));
    float vignette = 1.0 - dist;
    vignette = smoothstep(0.0, 0.7, vignette);
    vignette = remap(vignette, 0.0, 1.0, 0.3, 1.0);
    return vec3(vignette);
}

vec3 draw_grid(vec3 color, vec3 lineColor, float cellSpacing, float lineWidth) {
    vec2 center = v_uv - 0.5;
    vec2 cell = abs(fract(center * u_resolution / cellSpacing) - 0.5);
    float dist = (0.5 - max(cell.x, cell.y)) * cellSpacing;
    float line = smoothstep(0.0, lineWidth, dist);
        
    color = mix(lineColor, color, line);
    return color;
}

float sdfCircle(vec2 p, float r) {
    return length(p) - r;
}

float sdfLine(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

float sdfBox(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

mat2 rotate2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(
        c, -s, 
        s, c
    );
}

// simple shapes
// void main() {
//     vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    
//     vec3 color = bg_color();
//     color = draw_grid(color, vec3(0.5), 10.0, 1.0);
//     color = draw_grid(color, vec3(0.0), 100.0, 2.0);

//     // float d = sdfCircle(pixel_coords, 100.0);
//     // color = mix(vec3(0.5, 0.0, 0.0), color, step(0.0, d));

//     // float d = sdfLine(pixel_coords, vec2(-100.0, -50.0), vec2(200.0, -75.0));
//     // color = mix(vec3(0.5, 0.0, 0.0), color, step(5.0, d));

//     float d = sdfBox(pixel_coords, vec2(300.0, 100.0));
//     color = mix(vec3(0.5, 0.0, 0.0), color, step(0.0, d));

//     gl_FragColor = vec4(color, 1.0);
// }

// transformations
// void main() {
//     vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    
//     vec3 color = bg_color();
//     color = draw_grid(color, vec3(0.5), 10.0, 1.0);
//     color = draw_grid(color, vec3(0.0), 100.0, 2.0);

//     vec2 pos = pixel_coords - vec2(100.0, 100.0);
//     pos *= rotate2d(u_time * 0.25);

//     float d = sdfBox(pos, vec2(200.0, 50.0));
//     color = mix(vec3(0.5, 0.0, 0.0), color, step(0.0, d));

//     gl_FragColor = vec4(color, 1.0);
// }

// antialiasing && shading
void main() {
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;

    vec3 color = bg_color();
    color = draw_grid(color, vec3(0.5), 10.0, 1.0);
    color = draw_grid(color, vec3(0.0), 100.0, 2.0);

    float d = sdfCircle(pixel_coords, 200.0);
    color = mix(vec3(1.0, 0.0, 0.0) * 0.5, color, smoothstep(-1.0, 1.0, d));
    color = mix(vec3(1.0, 0.0, 0.0), color, smoothstep(-5.0, 0.0, d));

    gl_FragColor = vec4(color, 1.0);
}
