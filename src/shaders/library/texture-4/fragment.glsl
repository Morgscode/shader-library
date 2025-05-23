#define PI 3.1415926535

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;
uniform sampler2D u_texturemap;

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
float fbm(vec3 p, int octaves, float persistence, float lacunarity) 
{
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

void main()
{
    /// center texture coords
    vec2 uv = v_uv * 2.0 - 1.0;
    /// get texture based px coords
    vec2 px_coords = (v_uv - 0.5) * u_resolution;
    /// modulate noise sample over time
    float time_mod = (abs(sin(u_time)) * 0.5 + 0.5) * PI;
    float noise_sample = fbm(
        vec3(px_coords * 0.005, time_mod * 0.5), 
        8, 
        0.5, 
        2.0
    );

    /// add time-based shift for the monitor filter
    vec2 l_uv = uv;
    l_uv.y += u_time * 0.001;
    /// draw a line for the monitor filter
    float line = smoothstep(
        1.0, 
        0.1,
        sin(l_uv.y * u_resolution.y) / PI
    );
    float distortion = remap(noise_sample, -1.0, 1.0, 0.0, PI);
    vec4 t_sample; 
    /// position the image based on time and apply distorion
    if (fract(u_time) > 0.8) {
        t_sample = texture2D(u_texturemap, v_uv); 
    } else {
        t_sample = texture2D(u_texturemap, v_uv - (distortion  / u_resolution * 20.0));
    }

    vec3 color = mix(vec3(0.0), t_sample.xyz, line);
    float l = length(uv) * exp(-length(uv));
    float l2 = l * remap(tan(u_time), -1.0, 1.0, 0.0, 0.33);

    /// alter the lighting based on time and paint the pixel
    if (fract(u_time) > 0.6) {
        gl_FragColor = vec4((color - l) * (l2 * PI), 1.0); 
    } else {
        gl_FragColor = vec4((color - l) / (l * PI), 1.0);
    }
}