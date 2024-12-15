#define PI 3.1415926535

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

// https://iquilezles.org/articles/distfunctions2d/

float ndot(vec2 a, vec2 b ) { return a.x*b.x - a.y*b.y; }
float sdRhombus( in vec2 p, in vec2 b ) 
{
    p = abs(p);
    float h = clamp( ndot(b-2.0*p,b)/dot(b,b), -1.0, 1.0 );
    float d = length( p-0.5*b*vec2(1.0-h,1.0+h) );
    return d * sign( p.x*b.y + p.y*b.x - b.x*b.y );
}

float sdHexagram( in vec2 p, in float r )
{
    const vec4 k = vec4(-0.5,0.8660254038,0.5773502692,1.7320508076);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= 2.0*min(dot(k.yx,p),0.0)*k.yx;
    p -= vec2(clamp(p.x,r*k.z,r*k.w),r);
    return length(p)*sign(p.y);
}

float sdEquilateralTriangle( in vec2 p, in float r )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
}

float sdVesica(vec2 p, float r, float d)
{
    p = abs(p);
    float b = sqrt(r*r-d*d);
    return ((p.y-b)*d>p.x*b) ? length(p-vec2(0.0,b))
                             : length(p-vec2(-d,0.0))-r;
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

// procedural pixel art
// void main() {
//     vec2 pixel_cords = (v_uv - 0.5) * u_resolution;
//     vec3 color = vec3(0.0);
//     float angle = u_time / 1.30;

//     for (float i = 0.0; i < 26.0; i += 1.0) {
//         vec2 uv = fract(abs(pixel_cords) * PI);
//         uv -= 0.5;
//         uv *= 1.1;
//         uv *= rotate2d(sin(angle));
//         float d = sdRhombus(uv, vec2(300.0, 150.0));
//         color += mix(palette(u_time), color, smoothstep(0.0, 0.002, fract(d)));
//     }
   
//     gl_FragColor = vec4(color, 1.0);
// }

// procedural geometry art
void main() {
    // center our uvs
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    // store ref of original centered uvs
    vec2 l_uv = uv;
    vec3 final = vec3(0.0);
    // overall speed of the animation - tweaked to bpm
    float angle = u_time / 1.30;

    for (float i = 0.0; i < 3.0; i += 1.0) {
        uv = (fract(uv * 2.0) - 0.5) * 1.1 * rotate2d(sin(angle));
        vec3 color = palette(length(l_uv) + smoothstep(0.0, 0.002, PI) + angle);

        // this is the length we'll pass to any sdf
        float l =  length(uv) * exp(-length(l_uv));
        // any sdf can go here
        float d = sdVesica(l_uv, l, i);

        // smooth out the visuals
        d = sin(d * 2.0 + i - angle) / 2.0;
        d = sin(abs(d));
        d = mod(0.01 / d, 1.5);

        final += mix(final, color, d);
    }
   
    gl_FragColor = vec4(final, 1.0);
}