#define PI 3.1415926535
#define BPM 130.0

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

// https://iquilezles.org/articles/distfunctions2d/
float sdEquilateralTriangle( in vec2 p, in float r )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p = vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
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