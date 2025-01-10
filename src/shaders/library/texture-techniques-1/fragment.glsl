varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;
uniform sampler2D u_texturemap;

void main() 
{
    vec2 uv = mod((v_uv - 0.5) * sin(u_time / 2.6) + 0.5, 1.0);
    gl_FragColor = texture2D(u_texturemap, uv) * vec4(v_uv.x, abs(sin(u_time * 0.26)), v_uv.y, 1.0);
}