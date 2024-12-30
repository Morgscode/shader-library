#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

/// https://iquilezles.org/articles/distfunctions2d/
float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float i_lerp(float value, float min_val, float max_val)
{
    return (value - min_val) / (max_val - min_val);
}

float remap(float value, float in_min, float in_max, float out_min, float out_max)
{
    float t = i_lerp(value, in_min, in_max);
    return mix(out_min, out_max, t);
}

void main() 
{
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    float hbar_length = (u_resolution.x / 2.0) / 100.0 * 80.0;
    float hbar_height = (u_resolution.y / 2.0) / 100.0 * 10.0;
    vec3 color = vec3(0.3, 0.5, 0.9);
    float time = u_time * (BPM * 0.01);

    /// healthbar bg
    {
        float d = sdBox(pixel_coords, vec2(hbar_length, hbar_height) + 3.0) - 3.0;
        color = mix(
            vec3(0.0), 
            color, 
            smoothstep(0.0, 1.0, d)
        );
    }
    {
        float d = sdBox(pixel_coords, vec2(hbar_length, hbar_height)) - 3.0;
        color = mix(
            vec3(1.0), 
            color, 
            smoothstep(0.0, 1.0, d)
        );
    }

    /// health bar
    {
        float time_cycle = mod(time, 15.0); 
        float grow = smoothstep(7.0, 15.0, time_cycle); 
        float shrink = smoothstep(0.0, 7.5, time_cycle); 
        float phase = 1.0 - grow;
        float health = shrink * phase * hbar_length;
        health = hbar_length - clamp(0.0, health, hbar_length);
        float d = sdBox(
            pixel_coords + vec2((hbar_length + 3.0) - health, 0.0), 
            vec2(health, (hbar_height + 3.0))
        );
        vec3 health_color = mix(
            vec3(1.0, 0.0, 0.0), 
            vec3(0.0, 1.0, 0.0), 
            remap(health, 0.0, hbar_length, 0.0, 1.0)
        );
        
        color = mix(
            health_color, 
            color, 
            smoothstep(0.0, 1.0, d)
        );
    }

    gl_FragColor = vec4(color, 1.0);
}