#define PI 3.1415926535
#define BPM 135.0

varying vec2 v_uv;

uniform vec2 u_resolution;
uniform float u_time;

/// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
        vec3 a = vec3(0.5, 0.5, 0.5);
        vec3 b = vec3(0.5, 0.5, 0.5);
        vec3 c = vec3(1.0, 1.0, 1.0);
        vec3 d = vec3(0.0, 0.3, 0.6);

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

/// https://en.wikipedia.org/wiki/Rotation_matrix
mat2 rotate2d(float angle)
{
    return mat2(
        cos(angle), -sin(angle),
        sin(angle), cos(angle)
    );
}

/// https://iquilezles.org/articles/distfunctions2d/
float sdHexagon( in vec2 p, in float r )
{
    const vec3 k = vec3(-0.866025404,0.5,0.577350269);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= vec2(clamp(p.x, -k.z*r, k.z*r), r);
    return length(p)*sign(p.y);
}

void main() 
{
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x/u_resolution.y;  
    vec2 l_uv = uv; 
    vec3 final = vec3(0.0);
    float angle = u_time / (BPM * 0.01);
    float noise_sample = fbm(vec3(l_uv, angle) * 0.005, 2, 0.5, sin(angle));
    
    for (float i = 0.0; i < 3.0; i += 1.0)
    {
        uv = fract(uv * 2.0) - 0.5;
        uv = abs(uv);
        uv *= -rotate2d(angle + noise_sample);
        uv += noise_sample;

        vec3 color = palette(length(uv) + angle + noise_sample);
        float l = length(uv) * exp(-length(l_uv));
        float d = sdHexagon(uv, l);
        d = sin(d * 8.0 + angle) / 4.0;
        d = abs(d);
        d = mod(0.01 / d, 2.0);

        final += color * d;
    }

    gl_FragColor = vec4(final, 1.0);
}