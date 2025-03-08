import type { Shader } from '../';
import baseVertex from '../base-vertex.glsl';
import proceduralGeometry1 from './procedural-geometry-1/fragment.glsl';
import pixelart from './procedural-pixel-art-1/fragment.glsl';
import horizontalSinWave from './horizontal-sinwave/fragment.glsl';
import psychedellicVisuals1 from './psychedellic-visuals-1/fragment.glsl';
import theVoid from './the-void/fragment.glsl';
import fbmFractals from './fbm-fractals/fragment.glsl';
import pong from './pong/fragment.glsl';
import proceduralGeometry2 from './procedural-geometry-2/fragment.glsl';
import texture2 from './texture-2/fragment.glsl';
import texture3 from './texture-3/fragment.glsl';
import healthbar from './healthbar/fragment.glsl';
import grid from './grid/fragment.glsl';
import tieDIe from './tie-dye/fragment.glsl';
import terrain1 from './terrain-1/fragment.glsl';
import juliaSet from './julia-set/fragment.glsl';
import texture4 from './texture-4/fragment.glsl';

const base: Shader = {
    title: '',
    fragment: ``,
    vertex: baseVertex,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
    hidden: false,
};

export const shaders: Record<string, Shader> = {
    "grid": {
        ...base,
        title: "GLSL grid example",
        fragment: grid,
        hidden: true,
    },
    "pong": {
        ...base,
        title: "Pong",
        fragment: pong,
        hidden: true,
    },
    "horizontal-sinwave": {
        ...base,
        title: "Horizontal sinwave (130 BPM)",
        fragment: horizontalSinWave,
    },
    "psychedellic-visuals-1": {
        ...base,
        title: "Psychedellic visuals #1",
        fragment: psychedellicVisuals1,
    },
    "the-void": {
        ...base,
        title: "The Void",
        fragment: theVoid,
    },
    "texture-2": {
        ...base,
        title: "Texture #2",
        fragment: texture2,
        texture: './assets/images/galactic-core.webp',
    },
    "procedural-pixel-art-1": {
        ...base,
        title: "Procedural pixel art #1",
        fragment: pixelart,
    },
    "procedural-geometry-1": {
        ...base,
        title: "Procedural geometry #1",
        fragment: proceduralGeometry1,
    },
    "procedural-geometry-2": {
        ...base,
        title: "Procedural geometry #2",
        fragment: proceduralGeometry2,
    },
    "fbm-fractals": {
        ...base,
        title: "Fractals with FBM",
        fragment: fbmFractals,
    },
    "texture-3": {
        ...base,
        title: "Texture #3",
        fragment: texture3,
        texture: './assets/images/galactic-core.webp',
    },
    "healthbar": {
        ...base,
        title: "Healthbar",
        fragment: healthbar,
    },
    "tie-dye": {
        ...base,
        title: "Tie Dye",
        fragment: tieDIe
    },
    "terrain-1": {
        ...base,
        title: "Terrain #1",
        fragment: terrain1,
    },
    "quadratic-julia-set": {
        ...base,
        title: "Julia Set",
        fragment: juliaSet,
    },
    "texture-4": {
        ...base,
        title: "Texture #4",
        fragment: texture4,
        texture: './assets/images/model.webp',
    }
};