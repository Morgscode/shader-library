#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2  u_resolution;
uniform sampler2D u_texturemap;
uniform vec4 u_tint;

void main() 
{   
    vec4 sample1 = texture2D(u_texturemap, v_uv);
    vec2 uv = v_uv;
    uv.y += u_time * 0.0005;
    float line = smoothstep(-0.5, 0.5, sin((-uv.y) * 1000.0));
    vec3 color = vec3(line);
    gl_FragColor = sample1 * vec4(color, 0.5);
}