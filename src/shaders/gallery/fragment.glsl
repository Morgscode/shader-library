#define PI 3.1415926535

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

float ndot(vec2 a, vec2 b ) { return a.x*b.x - a.y*b.y; }
float sdRhombus( in vec2 p, in vec2 b ) 
{
    p = abs(p);
    float h = clamp( ndot(b-2.0*p,b)/dot(b,b), -1.0, 1.0 );
    float d = length( p-0.5*b*vec2(1.0-h,1.0+h) );
    return d * sign( p.x*b.y + p.y*b.x - b.x*b.y );
}

vec3 palette(float t) {
        vec3 a = vec3(0.8, 0.3, 0.2);
        vec3 b = vec3(0.6, 0.4, 0.8);
        vec3 c = vec3(0.6, 0.3, 0.2);
        vec3 d = vec3(2.9, 3.02, -0.27);

        return a + b * cos((PI * 2.0) * (c * t + d));
}

mat2 rotate2d(float p) {
    return mat2(
        cos(p), -sin(p),
        sin(p), cos(p)
    );
}

// fractal pixel art
void main() {
    vec2 pixel_cords = (v_uv - 0.5) * u_resolution;
    vec3 color = vec3(0.0);

    for (float i = 0.0; i < 26.0; i += 1.0) {
        vec2 uv = fract(abs(pixel_cords) * PI);
        uv -= 0.5;
        uv *= 1.1;
        uv *= rotate2d(sin(u_time * 1.30));
        float d = sdRhombus(uv, vec2(300.0, 150.0));
        color += mix(palette(u_time) * sin(u_time / 130.0), color, smoothstep(0.0, 0.004, fract(d)));
    }
   
    gl_FragColor = vec4(color, 1.0);
}