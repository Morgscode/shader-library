#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;

/// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
    vec3 a = vec3(0.6, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.6, 0.5);
    vec3 c = vec3(0.6, 0.6, 0.5);
    vec3 d = vec3(0.2, 0.0, 0.5);

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
float turbulence_fbm(
    vec3 p,
    int octaves,
    float persistence,
    float lacunarity
) {
    float amplitude = 1.5;
    float frequency = 0.5;
    float total = 0.0;
    float normalization = 0.0;

    for(int i = 0; i < octaves; ++i) {
        float noiseValue = noise(p * frequency);
        noiseValue = abs(noiseValue);
        total += noiseValue * amplitude;
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

void main() 
{
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    vec2 l_uv = uv;
    float angle = u_time * (BPM * 0.01);
    float noise_sample = turbulence_fbm(
        vec3(pixel_coords, 1.0 - (u_mousepos.x - u_mousepos.y)) * 0.005, 
        2, 
        0.5, 
        2.0
    );

    uv = abs(uv);
    uv *= noise_sample;

    float l = length(uv) + exp(-length(l_uv));
    float dye = l + (angle * 0.1) + noise_sample;
    l = sin(dye);
    l = abs(l);
    l = mod(0.01 / l, 1.5);
    vec3 color = palette(dye * 2.0 + l) / PI;

    gl_FragColor = vec4(color, 1.0);
}