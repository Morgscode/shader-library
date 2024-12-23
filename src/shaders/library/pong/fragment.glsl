varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void main() 
{
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    vec2 l_uv = pixel_coords;
    vec2 r_uv = pixel_coords;
    vec3 color = vec3(0.3, 0.5, 0.9);
    
    // left paddle
    {
        float d = sdBox(pixel_coords + vec2((u_resolution.x / 2.0 - 50.0), 0.0), vec2(10.0, 50.0));
        color = mix(vec3(1.0), color, smoothstep(0.0, 0.002, d));
    }

    // right paddle
    {
        float d = sdBox(pixel_coords + vec2(-(u_resolution.x / 2.0 - 50.0), 0.0), vec2(10.0, 50.0));
        color = mix(vec3(1.0), color, smoothstep(0.0, 0.002, d));
    }

    // ball
    {
        float d = sdBox(pixel_coords, vec2(10.0, 10.0));
        color = mix(vec3(1.0), color, smoothstep(0.0, 0.002, d));
    }
    
    gl_FragColor = vec4(color, 1.0);
}