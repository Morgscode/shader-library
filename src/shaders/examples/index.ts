import type { Shader } from '../';
import baseVertex from '../base-vertex.glsl';
import solid from './solid-color/fragment.glsl';
import gradient from './gradient/fragment.glsl';

const base: Shader = {
    fragment: ``,
    vertex: baseVertex,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
}

export const shaders: Record<string, Shader> = {
    "solid-color": {
        ...base,
        fragment: solid,
    },
    "gradient": {
        ...base,
        fragment: gradient,
    }
};