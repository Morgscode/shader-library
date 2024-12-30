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
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.y += u_time * 0.001;
    float line = smoothstep(
        -1.0, 
        0.001, 
        sin(uv.y * u_resolution.y)
    );
    vec3 color = mix(vec3(0.0), sample1.xyz, line);
    gl_FragColor = vec4(color, 1.0);
}