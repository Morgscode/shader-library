#define PI 3.14159265359

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

float plot(vec2 st, float pct) {
     return smoothstep( pct - 0.02, pct, st.y) -
          smoothstep( pct, pct + 0.02, st.y);
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float y = pow(st.x, PI);

    vec3 color = vec3(y);

    float pct = plot(st, y);
    color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}
