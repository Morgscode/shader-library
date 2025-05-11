#define BPM 130.0
#define MAX_ITERATIONS 150.0
#define PI 3.1415926535

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

/// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
        vec3 a = vec3(0.821, 0.328, 0.242);
        vec3 b = vec3(0.659, 0.481, 0.896);
        vec3 c = vec3(0.612, 0.340, 0.296);
        vec3 d = vec3(2.820, 3.026, -0.273);

        return a + b * cos((PI * 2.0) * (c * t + d));
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

/// ensure c is always remapped to it's most "trippy" values
vec2 set_c(float t)
{
    return vec2(
        -0.8 + 0.2 * remap(cos(t), -1.0, 1.0, 0.0, 0.25), 
        0.156 + 0.2 * remap(sin(t), -1.0, 1.0, -0.25, 0.00)
    );
}

void main()
{
    /// center texture coords
    vec2 uv = v_uv * 2.0 - 1.0;
    /// make screen responsive
    uv.x *= u_resolution.x / u_resolution.y;
    vec2 l_uv = uv;
    vec2 z_uv = uv;
    float angle = u_time * (BPM * 0.001);
    /// fixed view shift left
    uv.x -= 1.0;
    /// add phased shift
    uv.x -= remap(sin(angle), -1.0, 1.0, 1.75, 0.0);
    /// https://en.wikipedia.org/wiki/Julia_set
    /// https://www.shadertoy.com/view/NdSGRG
    vec2 z = z_uv / remap(-sin(angle), -1.0, 1.0, 5.0, 3.0);
    float iterations = 0.0;
    vec2 c = set_c(angle);
    for (float i = 0.0; i < MAX_ITERATIONS; i++) 
    {
        /// if sqrt of z*z > 4.0 then stop painting
        if (dot(z, z) > 4.0) break;
        /// z*z+c
        z = vec2(
            z.x * z.x - z.y * z.y,
            2.0 * z.x * z.y
        ) + c;
        iterations += 1.0;
    }

    float t = iterations / MAX_ITERATIONS;
    float l = length(l_uv) * exp(-length(z));
    vec3 color = 1.0 - palette(l + t);

    gl_FragColor = vec4(color, 1.0);
}