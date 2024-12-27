#define PI 3.1415926535

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;

void main() 
{ 
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    gl_FragColor = vec4(uv.x, smoothstep(0.0, 0.01, sin(uv.x * uv.y * pow(u_time, PI) * 1.30)), uv.y, 1.0);
}