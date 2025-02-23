#define BPM 130.0
#define PI 3.1415926535

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

/// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
        vec3 a = vec3(0.667, 0.5, 0.5);
        vec3 b = vec3(0.500, 0.667, 0.5);
        vec3 c = vec3(0.667, 0.666, 0.5);
        vec3 d = vec3(0.2, 0.0, 0.5);

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

/// https://en.wikipedia.org/wiki/Rotation_matrix
mat2 rotate2d(float angle) 
{
    return mat2(
        cos(angle), -sin(angle),
        sin(angle), cos(angle)
    );
}

void main()
{
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    float angle = u_time * (BPM * 0.001);
    uv.x -= remap(sin(angle), -1.0, 1.0, -1.0, 2.0);
    uv.y -= remap(sin(angle), -1.0, 1.0, -0.25, 0.25);
    uv *= rotate2d(angle / 2.0);
    vec2 z = uv / remap(-sin(angle), -1.0, 1.0, 5.0, 2.0);
  
    /// https://en.wikipedia.org/wiki/Julia_set
    /// https://www.shadertoy.com/view/NdSGRG
    vec2 c = vec2(
        0.5 * remap(cos(2.0 * angle), -1.0, 1.0, 0.95, 1.0), 
        0.5 * remap(sin(3.0 * angle), -1.0, 1.0, 0.95, 1.0)
    );
    float iterations = 0.0;
    for (float i = 0.0; i < BPM; i++) 
    {
        if (dot(z, z) > 4.0) break;
        float x2 = z.x * z.x - z.y * z.y;
        float y2 = 2.0 * z.x * z.y;
        z = vec2(
            x2 * z.x - y2 * z.y,
            x2 * z.y + y2 * z.x 
        ) + c;
        iterations += 1.0;
    }

    float t = iterations / BPM;
    float l = length(uv) * exp(-length(z));
    float l2 = (length(uv) + remap(sin(angle), -1.0, 1.0, 3.0, 2.0) / 2.0);
    vec3 color = palette(l) + t;

    gl_FragColor = vec4(color / l2, 1.0);
}