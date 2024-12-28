#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2  u_resolution;
uniform sampler2D u_texturemap;
uniform vec4 u_tint;

void main() 
{   
    vec3 color = vec3(0.0);
    vec2 uv = v_uv;
    uv.y += (u_time * 0.0005);
    float t = smoothstep(-abs(sin(u_resolution.y)), abs(sin(u_resolution.y)), sin((-uv.y) * u_resolution.y * 2.0));
    color = vec3(t);
    gl_FragColor = texture2D(u_texturemap, v_uv) * vec4(color, 0.1);
}