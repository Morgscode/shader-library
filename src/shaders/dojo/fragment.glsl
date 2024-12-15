#define PI 3.1415926535
#define BPM 130.0

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

// https://github.com/Erkaman/glsl-cos-palette
vec3 palette(float t) {
        vec3 a = vec3(0.8, 0.3, 0.2);
        vec3 b = vec3(0.6, 0.4, 0.8);
        vec3 c = vec3(0.6, 0.3, 0.2);
        vec3 d = vec3(2.9, 3.02, -0.27);

        return a + b * cos((PI * 2.0) * (c * t + d));
}

// https://en.wikipedia.org/wiki/Rotation_matrix
mat2 rotate2d(float p) {
    return mat2(
        cos(p), -sin(p),
        sin(p), cos(p)
    );
}

// procedural pixel art
void main() {
    // get responsive pixel coords for screen
    vec2 pixel_cords = (v_uv - 0.5) * u_resolution;
    // bg color
    vec3 final = vec3(0.0);
    // store local ref to uv cords for screen
    vec2 l_uv = v_uv * 2.0 - 1.0;
    l_uv.x *= u_resolution.x / u_resolution.y;
    float angle = u_time / BPM;

    for (float i = 0.0; i < 3.0; i += 1.0) {
        // scale the positive values from pixel cords, fract and scale again
        vec2 uv = (fract(abs(pixel_cords) * PI) - 0.5) * 1.1;
        // begin rotation
        uv *= rotate2d(angle);
        // bring in the sdf we want the pixels to draw around
        float d = sdEquilateralTriangle(uv, angle);
        vec3 color = palette(length(l_uv) + i + sin((angle)));
        final = mix(color, final, smoothstep(0.0, 0.02, fract(d)));
    }
   
    gl_FragColor = vec4(final, 1.0);
}

// procedural geometry art
// void main() {
//     // center our uvs
//     vec2 uv = v_uv * 2.0 - 1.0;
//     uv.x *= u_resolution.x / u_resolution.y;
//     // store ref of original centered uvs
//     vec2 l_uv = uv;
//     vec3 final = vec3(0.0);
//     // overall speed of the animation - tweaked to bpm
//     float angle = u_time + BPM;

//     for (float i = 0.0; i < 3.0; i += 1.0) {
//         // scale, fract and then recenter the uv coords
//         uv = (fract(uv * 2.0) - 0.5) * 1.1;
//         // begin rotating 
//         uv *= rotate2d(sin(angle));
//         vec3 color = palette(length(l_uv) + i + angle);

//         // this is the length we'll pass to any sdf
//         float l =  length(uv) * exp(-length(l_uv));
//         // any sdf can go here
//         float d = sdVesica(l_uv, l, i);

//         // smooth out the visuals
//         d = sin(d * 4.0 + i + angle) / 4.0;
//         d = sin(abs(d));
//         d = mod(0.01 / d, 1.5);

//         final = mix(final, color, d);
//     }
   
//     gl_FragColor = vec4(final, 1.0);
// }