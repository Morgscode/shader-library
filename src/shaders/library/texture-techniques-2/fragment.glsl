#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2  u_resolution;
uniform sampler2D u_texturemap;
uniform vec4 u_tint;

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

/// https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
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

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

void main() {
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    float noise_sample = fbm(
        vec3(pixel_coords, 0.0) * 0.005, 
        4, 
        0.5, 
        2.0
    );
    float time_cycle = mod(u_time * (BPM * 0.01), 15.0); 
    float grow = smoothstep(0.0, 7.5, time_cycle); 
    float shrink = smoothstep(7.5, 15.0, time_cycle); 
    float phase = 1.0 - shrink;
    float size = grow * phase * (50.0 + length(u_resolution) * 0.5);
    
    float d = sdCircle(pixel_coords + 50.0 * noise_sample, size);
    vec2 distortion = noise_sample / u_resolution;
    distortion = distortion * 20.0 * smoothstep(80.0, 20.0, d);
    vec3 sample1 = texture2D(u_texturemap, v_uv + distortion).xyz;

    vec2 uv = 1.0 - mod((v_uv - 0.5) * sin(u_time * (BPM * 0.01) / 5.0) + 0.5, 1.0);
    vec3 sample2 = (texture2D(u_texturemap, uv) * u_tint).xyz;

    float warp = 1.0 - exp(-d * d * 0.001);
    vec3 color = mix(vec3(0.0), sample1, warp);
    color = mix(sample2, color, smoothstep(0.0, 1.0, d));
    
    float glow = smoothstep(0.0, 32.0, abs(d));
    glow = 1.0 - pow(glow, 0.125);
    color += glow * u_tint.xyz;
    
    gl_FragColor = vec4(color, 1.0);
}