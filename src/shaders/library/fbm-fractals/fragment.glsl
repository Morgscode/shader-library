#define PI 3.1415926535
#define BPM 130.0

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

/// https://iquilezles.org/
/// https://www.shadertoy.com/view/Xsl3Dl
vec3 hash( vec3 p )
{
	p = vec3( 
        dot(p, vec3(127.1,311.7, 74.7)),
        dot(p, vec3(269.5,183.3,246.1)),
        dot(p, vec3(113.5,271.9,124.6))
    );

	return - 1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

/// https://iquilezles.org/
/// https://www.shadertoy.com/view/Xsl3Dl
float noise( in vec3 p )
{
    vec3 i = floor(p);
    vec3 f = fract(p);
    vec3 u = f * f * (3.0 - 2.0 * f);

    return mix( 
        mix( 
            mix( 
                dot(hash(i + vec3(0.0,0.0,0.0)), f - vec3(0.0,0.0,0.0)), 
                dot(hash(i + vec3(1.0,0.0,0.0)), f - vec3(1.0,0.0,0.0)), 
                u.x
            ),
            mix( 
                dot(hash(i + vec3(0.0,1.0,0.0)), f - vec3(0.0,1.0,0.0)), 
                dot(hash(i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0)),
                u.x
            ), 
            u.y
        ),
        mix( 
            mix(
                dot(hash(i + vec3(0.0,0.0,1.0)), f - vec3(0.0,0.0,1.0)), 
                dot(hash(i + vec3(1.0,0.0,1.0)), f - vec3(1.0,0.0,1.0)), 
                u.x
            ),
            mix( 
                dot(hash(i + vec3(0.0,1.0,1.0)), f - vec3(0.0,1.0,1.0)), 
                dot(hash(i + vec3(1.0,1.0,1.0)), f - vec3(1.0,1.0,1.0)), 
                u.x
            ), 
            u.y
        ),
        u.z 
    );
}

/// https://www.shadertoy.com/view/ss2cDK
float fbm(
    vec3 p, 
    int octaves, 
    float persistence, 
    float lacunarity
) {
  float amplitude = 0.5;
  float frequency = 1.0;
  float total = 0.0;
  float normalization = 0.0;

  for (int i = 0; i < octaves; ++i) {
    float noise_value = noise(p * frequency);
    total += noise_value * amplitude;
    normalization += amplitude;
    amplitude *= persistence;
    frequency *= lacunarity;
  }

  total /= normalization;

  return total;
}

/// https://en.wikipedia.org/wiki/Rotation_matrix
mat2 rotate2d(float angle) 
{
    return mat2(
        cos(angle), -sin(angle),
        sin(angle), cos(angle)
    );
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
    float angle = u_time * (BPM * 0.001);
    float noise_sample = fbm(
        vec3(pixel_coords, cos(angle) * PI) * 0.001, 
        3, 
        0.5, 
        remap(sin(angle), -1.0, 1.0, 4.0, -4.0)
    );
    vec2 uv = v_uv * 2.0 - 1.0;
    vec2 l_uv = uv;
    uv.x *= u_resolution.x / u_resolution.y;

    for (float i = 0.0; i < 64.0; i += 1.0) 
    {
        uv = (abs(uv) - 0.5) * 1.1;
        uv *= rotate2d(angle);
        uv += noise_sample;
    }

    float l = exp(length(uv)) * exp(-length(l_uv));
    vec3 color = palette(-cos(angle) / (l * remap(noise_sample, -1.0, 1.0, 0.0, 1.0)));

    gl_FragColor = vec4(color * length(uv), 1.0);
}