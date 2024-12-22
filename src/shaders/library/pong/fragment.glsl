varying vec2 v_uv;

uniform float u_time;

float paddle(float l)
{
    return smoothstep(-1.0, 1.0, l);
}

void main() 
{
    vec2 uv = v_uv * 2.0 - 1.0;
    vec2 l_uv = uv;
    vec3 color = vec3(0.3, 0.5, 0.9);
    float s = sin(u_time);
    uv.y += s;

    // left paddle
    if (distance(uv, vec2(-0.9, 0.0)) < 0.01) {
        float p = paddle(uv.y);
        color = mix(color, vec3(1.0), p);
    }

    // right paddle
    if (distance(uv, vec2(0.9, 0.0)) < 0.01) {
        float p = paddle(uv.y);
        color = mix(color, vec3(1.0), p);
    }

    gl_FragColor = vec4(color, 1.0);
}