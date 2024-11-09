uniform float u_time;
uniform sampler2D u_diffuse;

varying vec2 v_uv;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

// steady fade in/out
// void main() {
//     vec3 color = vec3(0.0);
//     float t = sin(u_time);
//     t = remap(t, -1.0, 1.0, 0.0, 1.0);

//     color = vec3(t);

//     gl_FragColor = vec4(color, 1);
// }

// static bars
// void main() {
//     vec3 color = vec3(0.5);

//     float t = sin(v_uv.y * 100.0);
//     color = vec3(t);

//     gl_FragColor = vec4(color, 1.0) ;
// }

// project challenge
void main() {
    vec3 color = vec3(0.5);
    
    vec4 diffuse_sample = texture2D(u_diffuse, v_uv);
    float t = sin(v_uv.y * 500.0);
    color = cos(vec3(t) * sin(u_time * v_uv.y));
   
    gl_FragColor = vec4(color, 1.0) * diffuse_sample;
}
