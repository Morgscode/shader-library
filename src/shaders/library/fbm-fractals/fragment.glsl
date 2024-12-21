#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
        vec3 a = vec3(0.8, 0.3, 0.2);
        vec3 b = vec3(0.6, 0.4, 0.8);
        vec3 c = vec3(0.6, 0.3, 0.2);
        vec3 d = vec3(2.9, 3.02, -0.27);

        return a + b * cos((PI * 2.0) * (c * t + d));
}

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org/
//
// https://www.shadertoy.com/view/Xsl3Dl
vec3 hash( vec3 p ) // replace this by something better
{
	p = vec3( 
        dot(p, vec3(127.1,311.7, 74.7)),
        dot(p, vec3(269.5,183.3,246.1)),
        dot(p, vec3(113.5,271.9,124.6))
    );

	return - 1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

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

vec3 fractals(float angle, vec3 color, float noise_val) 
{
    //  center our uvs
    vec2 uv = v_uv * 2.0 - 1.0;
    // make it responsive to the current screen size
    uv.x *= u_resolution.x / u_resolution.y;
    // start the fractal process
    for (float i = 0.0; i < 64.0; i += 1.0) {
        uv = abs(uv);
        uv -= 0.5;
        uv *= 1.1;
        uv *= mat2(
            cos(angle), -sin(angle),
            sin(angle), cos(angle)
        );
        uv += noise_val;
    }
    return vec3(color / PI * length(uv));
}

void main() 
{
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    float angle = u_time / (BPM / 10.0);
    float noise_sample = fbm(vec3(pixel_coords, angle) * 0.005, 4, 0.5, clamp(-1.0, 1.0, u_time));
    vec3 color = palette(dot(noise_sample, angle));
    color = fractals(angle, color, noise_sample);
    gl_FragColor = vec4(color, 1.0);
}