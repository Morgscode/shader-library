#define PI 3.1415626535

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;

/// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
        vec3 a = vec3(0.8, 0.3, 0.2);
        vec3 b = vec3(0.6, 0.4, 0.8);
        vec3 c = vec3(0.6, 0.3, 0.2);
        vec3 d = vec3(2.9, 3.02, -0.27);

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

float i_lerp(float value, float min_val, float max_val)
{
    return (value - min_val) / (max_val - min_val);
}

float remap(float value, float in_min, float in_max, float out_min, float out_max)
{
    float t = i_lerp(value, in_min, in_max);
    return mix(out_min, out_max, t);
}

vec3 deep_water()
{
    return vec3(0.0, 0.2, 1.0);
}

vec3 shallow_water()
{
    return vec3(0.3, 0.5, 0.9);
}

vec3 sand()
{
    return vec3(0.9, 0.8, 0.2);
}

vec3 grass()
{
    return vec3(0.2, 0.6, 0.2);
}

vec3 hills()
{
    return vec3(0.4, 0.4, 0.4);
}

vec3 hilltops()
{
    return vec3(0.5, 0.35, 0.5);
}

vec3 terrain(float elevation) 
{
    if (elevation < 0.4) {
        return mix(
            deep_water(), 
            shallow_water(), 
            smoothstep(0.2, 0.4, elevation)
        );
    } else if (elevation < 0.5) {
        return mix(
            sand(), 
            grass(), 
            smoothstep(0.4, 0.5, elevation)
        );
    } else if (elevation < 0.65) {
        return mix(
            grass(), 
            hills(), 
            smoothstep(0.5, 0.65, elevation)
        );
    } else {
        return mix(
            hills(), 
            hilltops(), 
            smoothstep(0.65, 0.75, elevation)    
        );
    }
}

void main()
{
    vec2 px_coords = ((v_uv) - 0.5) * u_resolution;
    vec2 pos = u_mousepos;
    pos.y = 1.0 - pos.y;
    float n_sample = fbm(
        vec3((px_coords + pos), u_resolution.x/u_resolution.y) * 0.01,
        8, 
        0.5, 
        2.0
    );
    n_sample = remap(n_sample, -1.0, 1.0, 0.0, 1.0);
    vec3 color = terrain(n_sample);
    gl_FragColor = vec4(color, 1.0);
}