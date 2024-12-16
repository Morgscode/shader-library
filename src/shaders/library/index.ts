import type { Shader } from '../';
import baseVertex from '../base-vertex.glsl';
import vesica from './procedural-vesica-geometry/fragment.glsl';
import pixelart from './procedural-pixelart/fragment.glsl';

const base: Shader = {
    fragment: ``,
    vertex: baseVertex,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
};

export const shaders: Record<string, Shader> = {
    "procedural-equilateral-triangle-pixel-art": {
        ...base,
        fragment: pixelart,
    },
    "procedural-vesica-geometry": {
        ...base,
        fragment: vesica,
    }
};