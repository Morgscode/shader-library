import type { Shader } from '../types';
import libraryVertex from '../library/vertex.glsl';
import geometry from './procedural-geometry/fragment.glsl';
import pixelart from './procedural-pixelart/fragment.glsl';

const base = {
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
} as Shader

export const library: Record<string, Shader> = {
    "procedural-pixel-art": {
        ...base,
        vertex: libraryVertex,
        fragment: pixelart,
    },
    "procedural-geometry": {
        ...base,
        vertex: libraryVertex,
        fragment: geometry,
    }
};