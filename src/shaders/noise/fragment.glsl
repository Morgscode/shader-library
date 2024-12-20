varying vec2 v_uv;

uniform float u_time;
uniform vec2  u_resolution;

float hashish(vec2 p) {
    p = 50.0 * fract(p * 0.3183099 + vec2(0.71, 0.113));
    return -1.0 + 2.0 * fract( p.x * p.y * (p.x + p.y));
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);

    return mix(
        mix(
            hashish(i + vec2(0.0)),
            hashish(i + vec2(1.0, 0.0)),
            u.x
        ),
        mix(
            hashish(i + vec2(0.0, 1.0)),
            hashish(i + vec2(1.0)),
            u.x
        ),
        u.y
    );
}

// simple pixel noise
void main() {
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    vec3 color = vec3(noise(uv * 20.0));
    gl_FragColor = vec4(color, 1.0);
}
