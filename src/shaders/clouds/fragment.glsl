#define NUM_CLOUDS 8.0

varying vec2 v_uv;
 
uniform float u_time;
uniform vec2 u_resolution;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
} 

float opUnion(float d1, float d2) {
  return min(d1, d2);
}

float opSubtraction(float d1, float d2) {
  return max(-d1, d2);
}

float opIntersection(float d1, float d2) {
  return max(d1, d2);
}

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

mat2 rotate2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(
        c, -s, 
        s, c
    );
}

vec3 draw_bg() {
    vec3 morning = mix(
        vec3(0.4, 0.6, 0.8),
        vec3(0.3, 0.5, 0.9),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    vec3 midday = mix(
        vec3(0.4, 0.5, 0.7),
        vec3(0.3, 0.4, 0.8),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    vec3 evening = mix(
        vec3(0.8, 0.5, 0.2),
        vec3(0.8, 0.7, 0.3),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    vec3 night = mix(
        vec3(0.1, 0.1, 0.1),
        vec3(0.1, 0.2, 0.3),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    float dayLength = 24.0;
    float dayTime = mod(u_time, dayLength);

    vec3 color = vec3(0.0);
    if (dayTime < dayLength * 0.25) {
        color = mix(morning, midday, smoothstep(0.0, dayLength * 0.25, dayTime));
    } else if (dayTime < dayLength * 0.5) {
        color = mix(midday, evening, smoothstep(0.0, dayLength * 0.25, dayTime));
    } else if (dayTime < dayLength * 0.75) {
        color = mix(evening, night, smoothstep(0.0, dayLength * 0.25, dayTime));
    } else {
        color = mix(night, morning, smoothstep(0.0, dayLength * 0.25, dayTime));
    }

    return color;
}

float sdCloud(vec2 pixel_coords) {
    float puff1 = sdCircle(pixel_coords, 100.0);
    float puff2 = sdCircle(pixel_coords - vec2(120.0, -10.0), 75.0);
    float puff3 = sdCircle(pixel_coords + vec2(120.0, 10.0), 75.0);
    return min(puff1, min(puff2, puff3));
}

float hashish(vec2 v) {
    float t = dot(v, vec2(42.069, 69.420));
    return sin(t);
}

// simple cloud scene
// void main() {
//     vec2 pixel_coords = (v_uv) * u_resolution;
//     vec3 color = mix(
    //     vec3(0.4, 0.5, 0.75),
    //     vec3(0.3, 0.4, 0.8),
    //     smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    // );

//     for (float i = 0.0; i < NUM_CLOUDS; i += 1.0) {
//         float size = mix(2.0, 1.0, (i / NUM_CLOUDS) + 0.1 * hashish(vec2(i)));
//         float speed = size * 0.25;
//         vec2 offeset = vec2(i * 200.0 + u_time * 20.0 * speed, 222.333 * hashish(vec2(i)));
//         vec2 pos = pixel_coords - offeset;
//         pos = mod(pos, u_resolution);
//         pos = pos - u_resolution * 0.5;
//         float cloud = sdCloud(pos * size);
//         float shadow = sdCloud(pos * size + vec2(50.0)) - 20.0;
//         color = mix(color, vec3(0.0), 0.5 * smoothstep(0.0, -100.0, shadow));
//         color = mix(vec3(1.0), color, smoothstep(0.0, 1.0, cloud));
//     }

//     gl_FragColor = vec4(color, 1.0);
// }

// day/night cycles
void main() {
    vec2 pixel_coords = (v_uv) * u_resolution;
    vec3 color = draw_bg();

    for (float i = 0.0; i < NUM_CLOUDS; i += 1.0) {
        float size = mix(2.0, 1.0, (i / NUM_CLOUDS) + 0.1 * hashish(vec2(i)));
        float speed = size * 0.25;
        vec2 offeset = vec2(i * 200.0 + u_time * 20.0 * speed, 222.333 * hashish(vec2(i)));
        vec2 pos = pixel_coords - offeset;
        pos = mod(pos, u_resolution);
        pos = pos - u_resolution * 0.5;
        float cloud = sdCloud(pos * size);
        float shadow = sdCloud(pos * size + vec2(50.0)) - 20.0;
        color = mix(color, vec3(0.0), 0.5 * smoothstep(0.0, -100.0, shadow));
        color = mix(vec3(1.0), color, smoothstep(0.0, 1.0, cloud));
    }

    gl_FragColor = vec4(color, 1.0);
}