varying vec2 v_uv;

uniform float u_time;

void main() 
{  
    gl_FragColor = vec4(v_uv.x, sin(v_uv.y * u_time * 130.0), v_uv.y, 1.0);
}