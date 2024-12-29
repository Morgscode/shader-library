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
    vec2 paddle_size = vec2(10.0, 50.0);
    float paddle_top_max = (u_resolution.y / 2.0) - 50.0;
    float paddle_bottom_min = -(u_resolution.y / 2.0) + 50.0;
    float paddle_x_offset = u_resolution.x / 2.0 - 50.0;
    vec3 color = vec3(0.3, 0.5, 0.9);
    
    /// left paddle
    {
        /// normalize the mouse/touch position to the paddle position
        float y_offset = u_resolution.y / 2.0 - u_mousepos.y;
        y_offset = clamp(y_offset, paddle_bottom_min, paddle_top_max);
        float d = sdBox(pixel_coords + vec2(paddle_x_offset, -y_offset), paddle_size);
        color = mix(
            vec3(1.0), 
            color, 
            smoothstep(0.0, 0.1, d)
        );
    }

    /// right paddle
    {
        float d = sdBox(pixel_coords + vec2(-(paddle_x_offset), 0.0), paddle_size);
        color = mix(
            vec3(1.0), 
            color, 
            smoothstep(0.0, 0.1, d)
        );
    }

    /// ball
    {
        float d = sdBox(pixel_coords, vec2(10.0, 10.0));
        color = mix(
            vec3(1.0), 
            color, 
            smoothstep(0.0, 0.1, d)
        );
    }
    
    gl_FragColor = vec4(color, 1.0);
}