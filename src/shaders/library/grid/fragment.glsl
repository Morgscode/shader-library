varying vec2 v_uv; 

uniform vec2 u_resolution;

void main()
{
    vec2 uv = v_uv * 2.0 - 1.0;
    vec3 color = vec3(0.7);
    vec3 white = vec3(0.0);
    vec3 black = vec3(0.0);

    // grid
    {   
        // fract the uvs into a grid of 75px cells
        vec2 cell = fract(uv * u_resolution / 100.0);
        cell = abs(cell - 0.5);
        // get dist of each cell 
        float dist = 1.0 - 2.0 * max(cell.x, cell.y);
        // draw a smooth line around the edge of the cell
        float c_line = smoothstep(0.0, 0.05, dist);
        color = mix(black, color, c_line);
    }

    // x axis
    {   
        float line = smoothstep(0.0, 1.0, abs(uv.y));
        color = mix(
            vec3(0.0, 0.0, 1.0),
            color, 
            smoothstep(0.0, 0.0001, line)
        );
    }

    // y axis
     {   
        float line = smoothstep(0.0, 1.0, abs(uv.x));
        color = mix(
            vec3(1.0, 0.0, 0.0),
            color, 
            smoothstep(0.0, 0.0001, line)
        );
    }

    gl_FragColor = vec4(color, 1.0);
}