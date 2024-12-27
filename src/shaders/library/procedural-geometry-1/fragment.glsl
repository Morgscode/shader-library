#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;

/// https://iquilezles.org/articles/distfunctions2d/
float sdVesica(vec2 p, float r, float d)
{
    p = abs(p);
    float b = sqrt(r*r-d*d);
    return ((p.y-b)*d>p.x*b) ? length(p-vec2(0.0,b))
                             : length(p-vec2(-d,0.0))-r;
}

/// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
        vec3 a = vec3(0.8, 0.3, 0.2);
        vec3 b = vec3(0.6, 0.4, 0.8);
        vec3 c = vec3(0.6, 0.3, 0.2);
        vec3 d = vec3(2.9, 3.02, -0.27);

        return a + b * cos((PI * 2.0) * (c * t + d));
}

/// https://en.wikipedia.org/wiki/Rotation_matrix
mat2 rotate2d(float p) 
{
    return mat2(
        cos(p), -sin(p),
        sin(p), cos(p)
    );
}

void main() 
{
    /// center our uvs
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    /// store ref of original centered uvs
    vec2 l_uv = uv;
    vec3 final = vec3(0.0);
    /// overall speed of the animation - tweaked to bpm
    float angle = u_time * (BPM * 0.01);

    for (float i = 0.0; i < 3.0; i += 1.0) 
    {
        uv = (fract(uv * 2.0) - 0.5) * 1.1;
        uv = abs(uv);
        uv *= rotate2d(sin(angle));

        vec3 color = palette(length(l_uv) + angle);
        /// this is the length we'll pass to any sdf
        float l =  length(uv) * exp(-length(l_uv));
        /// any sdf can go here
        float d = sdVesica(l_uv, l, i);
        /// smooth out the visuals
        d = sin(d * 4.0 + i + angle) / 4.0;
        d = sin(abs(d));
        d = mod(0.01 / d, 1.5);

        final = mix(final, color, d);
    }
   
    gl_FragColor = vec4(final, 1.0);
}