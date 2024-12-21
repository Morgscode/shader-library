varying vec2 v_uv;

uniform float u_time;

void main() 
{
    vec3 color = vec3(0.0);
    float line = smoothstep(0.0, 1.0, abs(v_uv.x - 0.5));
    color = abs(sin(vec3(line) * u_time * 130.0));

    color = mix(vec3(0.0), color, line);
    gl_FragColor = vec4(color, 1.0);
}