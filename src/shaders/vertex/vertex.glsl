varying vec3 v_normal; 
varying vec3 v_position;
varying vec4 v_color;

uniform float u_time;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

mat3 rotateY(float rads) {
    float s = sin(rads);
    float c = cos(rads);

    return mat3(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c
    );
}

// simple y-axis transform
// void main() {
//     vec3 localSpacePosition = position;

//     localSpacePosition.y += sin(u_time);

//     gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
//     v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
//     v_position = (modelMatrix * vec4(position, 1.0)).xyz;
// }

// 3-d scaling
// void main() {
//     vec3 localSpacePosition = position;

//     localSpacePosition *= remap(sin(u_time), -1.0, 1.0, 0.5, 1.5);

//     gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
//     v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
//     v_position = (modelMatrix * vec4(position, 1.0)).xyz;
// }

// simple y-axis rotation
// void main() {
//     vec3 localSpacePosition = position;

//     localSpacePosition = rotateY(u_time) * localSpacePosition;

//     gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
//     v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
//     v_position = (modelMatrix * vec4(position, 1.0)).xyz;
// }

// 
void main() {
    vec3 localSpacePosition = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
    
    v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
    v_position = (modelMatrix * vec4(position, 1.0)).xyz;

    vec3 red = vec3(1.0, 0.0, 0.0);
    vec3 blue = vec3(0.0, 0.0, 1.0);

    float t = remap(v_position.x, -0.5, 0.5, 0.0, 1.0);
    v_color = vec4(mix(red, blue, t), t);
}