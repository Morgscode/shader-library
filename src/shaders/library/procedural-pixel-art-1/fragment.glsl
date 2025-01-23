#define PI 3.1415926535
#define BPM 130.0

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mousepos;

/// https://iquilezles.org/articles/distfunctions2d/
float sdEquilateralTriangle( in vec2 p, in float r )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
}

/// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) 
{
        vec3 a = vec3(0.65, 0.5, 0.31);
        vec3 b = vec3(-0.65, 0.5, 0.6);
        vec3 c = vec3(0.333, 0.278, 0.278);
        vec3 d = vec3(0.6, 0.0, 0.67);

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
    vec2 pixel_cords = (v_uv - 0.5) * u_resolution;
    vec3 final = vec3(0.0);
    float angle = u_time * (BPM * 0.001);
    vec2 l_uv = v_uv * 2.0 - 1.0;
    l_uv.x *= u_resolution.x / u_resolution.y;
   
    for (float i = 0.0; i < 6.0; i += 1.0) 
    {
        vec2 uv = (fract(abs(pixel_cords) * PI) - 0.5) * 1.1;
        uv *= rotate2d(angle);
        float d = sdEquilateralTriangle(uv, abs(sin(angle)));
        vec3 color = palette(length(uv) + exp(-length(l_uv)) + angle);
        final = mix(
            smoothstep(0.2, 0.7, color), 
            final, 
            smoothstep(0.00, 0.04, fract(d))
        );
    }
   
    gl_FragColor = vec4(final, 1.0);
}