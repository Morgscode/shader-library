#define BPM 130.0
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

void main()
{
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    uv.x -= 1.0;
    float angle = u_time * (BPM * 0.001);
    vec2 l_uv = uv;
    uv.x -= remap(sin(angle), -1.0, 1.0, 1.0, 1.5);
    vec2 z = l_uv / remap(-sin(angle), -1.0, 1.0, 5.0, 3.0);
    /// https://en.wikipedia.org/wiki/Mandelbrot_sets
    ///https://gpfault.net/posts/mandelbrot-webgl.txt.html
    float iterations = 0.0;
    vec2 c = (remap(cos(angle), -1.0, 1.0, 0.8, 1.0) / 2.0) + (uv * 2.0 - vec2(2.0)) * (remap(sin(angle), -1.0, 1.0, 0.8, 1.0) / 4.0);
    for (float i = 0.0; i < BPM; i++) 
    {
        if (dot(z, z) > 5.0) break;
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (2.0 * z.x * z.y) + c.y;
        z = vec2(x, y);
        iterations += 1.0;
    }

    float t = iterations;
    float l = length(l_uv + c) * exp(-length(z));
    vec3 color = 1.0 - palette(l) + sin(t);

    gl_FragColor = vec4(color, 1.0);
}