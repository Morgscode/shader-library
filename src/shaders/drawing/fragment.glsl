#define PI 3.14159265359

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

float plot(vec2 st, float pct) {
     return smoothstep( pct - 0.02, pct, st.y) -
          smoothstep( pct, pct + 0.02, st.y);
}

// draw a striaght line
void main() {
    vec3 color = vec3(v_uv.x);

    float line = smoothstep(0.02, 0.0, abs(v_uv.x - v_uv.y));
    color = (1.0 - line) * color + line * vec3(0.0, 1.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}
 
// draw a curved line
// void main() {
//     vec2 uv = v_uv * 2.0 - 1.0;
//     float y = pow(v_uv.x, PI);

//     vec3 color = vec3(y);

//     float pct = plot(v_uv, y);
//     color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

//     gl_FragColor = vec4(color, 1.0);
// }

// draw a responsive circle with SDF
// void main() {
//     vec2 uv = v_uv * 2.0 - 1.0;
//     uv.x *= u_resolution.x / u_resolution.y;

//     float l = length(uv) - 0.5;

//     gl_FragColor = vec4(l, l, l, 1.0);
// }

// animate some circle geomtry
// void main() {
//     vec2 uv = v_uv * 2.0 - 1.0;
//     uv.x *= u_resolution.x / u_resolution.y;

//     float l = length(uv);

//     l = sin(l * 8.0 + u_time) / 8.0;
//     l = abs(l);

//     l = smoothstep(0.0, 0.1, l);

//     gl_FragColor = vec4(l, l, l, 1.0);
// }

// cosine based palette
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.75, 0.75, 0.75);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.333, 0.667);

    return a + b * cos(6.283185 * (c * t + d));
}

// procedural geomtery with color palette
// void main() {
//     vec2 uv = v_uv * 2.0 - 1.0;
//     uv.x *= u_resolution.x / u_resolution.y;
//     vec2 l_uv = uv;
//     vec3 final = vec3(0.0);

//     for (float i = 0.0; i < 3.0; i++) {
//         uv = fract(uv * PI) - 0.5;

//         float l = length(uv) * exp(-length(l_uv));
//         vec3 color = palette(length(l_uv) + i * 0.4 + u_time * 1.30);

//         l = sin(l * 8.0 + u_time) / 8.0;
//         l = abs(l);

//         l = pow(0.01 / l, 1.5);

//         final += color * l;
//     }

//     gl_FragColor = vec4(final, 1.0);
// }