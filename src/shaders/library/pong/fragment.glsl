varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;

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
    float top_max = (u_resolution.y / 2.0) - 50.0;
    float bottom_min = -(u_resolution.y / 2.0) + 50.0;
    
    // left paddle
    {
        float y_offset = u_resolution.y / 2.0 - u_mousepos.y;
        if (y_offset > top_max) {
            y_offset = top_max;
        }
        if (y_offset < bottom_min) {
            y_offset = bottom_min;
        }
        float d = sdBox(l_uv + vec2((u_resolution.x / 2.0 - 50.0), -y_offset), vec2(10.0, 50.0));
        color = mix(vec3(1.0), color, smoothstep(0.0, 0.1, d));
    }

    // right paddle
    {
        float d = sdBox(r_uv + vec2(-(u_resolution.x / 2.0 - 50.0), 0.0), vec2(10.0, 50.0));
        color = mix(vec3(1.0), color, smoothstep(0.0, 0.1, d));
    }

    // ball
    {
        float d = sdBox(pixel_coords, vec2(10.0, 10.0));
        color = mix(vec3(1.0), color, smoothstep(0.0, 0.1, d));
    }
    
    gl_FragColor = vec4(color, 1.0);
}