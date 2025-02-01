import type { Shader } from '../';
import baseVertex from '../base-vertex.glsl';
import proceduralGeometry1 from './procedural-geometry-1/fragment.glsl';
import pixelart from './procedural-pixel-art-1/fragment.glsl';
import horizontalSinWave from './horizontal-sinwave/fragment.glsl';
import psychedellicVisuals1 from './psychedellic-visuals-1/fragment.glsl';
import textures1 from './texture-techniques-1/fragment.glsl';
import theVoid from './the-void/fragment.glsl';
import fbmFractals from './fbm-fractals/fragment.glsl';
import pong from './pong/fragment.glsl';
import proceduralGeometry2 from './procedural-geometry-2/fragment.glsl';
import textures2 from './texture-techniques-2/fragment.glsl';
import textures3 from './texture-techniques-3/fragment.glsl';
import healthbar from './healthbar/fragment.glsl';
import grid from './grid/fragment.glsl';
import tieDIe from './tie-dye/fragment.glsl';
import terrain1 from './terrain-1/fragment.glsl';
import quadracticJuliaSet from './quadratic-julia-set/fragment.glsl';

const base: Shader = {
    title: '',
    fragment: ``,
    vertex: baseVertex,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
};

export const shaders: Record<string, Shader> = {
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
    "progressive-horizontal-sinwave": {
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
    "texture-techniques-1": {
        ...base,
        title: "Texture techniques #1",
        fragment: textures1,
        texture: './assets/images/galactic-core.webp',
    },
    "fbm-fractals": {
        ...base,
        title: "Fractals with FBM",
        fragment: fbmFractals,
    },
    "pong": {
        ...base,
        title: "Pong",
        fragment: pong,
    },
    "texture-techniques-2": {
        ...base,
        title: "Texture techniques #2",
        fragment: textures2,
        texture: './assets/images/galactic-core.webp',
    },
    "texture-techniques-3": {
        ...base,
        title: "Texture techniques #3",
        fragment: textures3,
        texture: './assets/images/galactic-core.webp',
    },
    "healthbar": {
        ...base,
        title: "Healthbar",
        fragment: healthbar,
    },
    "grid": {
        ...base,
        title: "GLSL grid example",
        fragment: grid,
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
        title: "Quadratic Julia Set",
        fragment: quadracticJuliaSet,
    }
};