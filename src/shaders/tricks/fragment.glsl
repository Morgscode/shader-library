uniform float u_time;

varying vec2 v_uv;

// step changes
// void main() {
//     gl_FragColor = vec4(vec3(step(0.5,v_uv.x), v_uv), 1.0);
// }

// smoothstep 
// void main() {
//     gl_FragColor = vec4(vec3(smoothstep(0.0, 1.0, v_uv.x), v_uv), 1.0);
// }

// mix 
// void main() {
//     gl_FragColor = vec4(vec3(mix(v_uv.x, v_uv.y, 1.0)), 1.0);
// }

//  smoothstep with mix 
// void main() {
//     gl_FragColor = vec4(mix(vec3(1.0, 0.0, 0.0), vec3(0.0,0.0,1.0), smoothstep(0.0, 1.0, v_uv.x)), 1.0);
// }

// drawing lines
void main() {
    vec3 color = vec3(0.0);

    float line = smoothstep(0.0001, 0.005, abs(v_uv.y - 0.5));
    float linearLine = smoothstep(0.0, 0.0075, abs(v_uv.y - mix(0.5, 1.0, v_uv.x)));
    float smoothLine = smoothstep(0.0, 0.0075, abs(v_uv.y - mix(0.0, 0.5, smoothstep(0.0, 1.0, v_uv.x))));

    color = vec3(line);

    if (v_uv.y > 0.5) {
        color = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), v_uv.x);
    } else {
        color = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), smoothstep(0.0, 1.0, v_uv.x));
    }

    color = mix(vec3(1.0, 1.0, 1.0), color, vec3(line));
    color = mix(vec3(1.0, 1.0, 1.0), color, linearLine);
    color = mix(vec3(1.0, 1.0, 1.0), color, smoothLine);

    gl_FragColor = vec4(color, 1.0);
}
