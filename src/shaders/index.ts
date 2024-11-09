import colorVertex from './colors/vertex.glsl';
import colorFragment from './colors/fragment.glsl';
import textureVertex from './textures/vertex.glsl';
import textureFragment from './textures/fragment.glsl';
import trickVertex from './tricks/vertex.glsl';
import trickFragment from './tricks/fragment.glsl'
import methodVertex from './methods/vertex.glsl';
import methodFragment from './methods/fragment.glsl';
import drawingVertex from './drawing/vertex.glsl';
import drawingFragment from './drawing/fragment.glsl';

export type Shader = {
    vertex: string;
    fragment: string;
    texture?: string;
}

export const colors: Shader = {
    vertex: colorVertex,
    fragment: colorFragment,
}

export const textures: Shader = {
    vertex: textureVertex,
    fragment: textureFragment,
    texture: './assets/images/galactic-core.webp'
}

export const tricks: Shader = {
    vertex: trickVertex,
    fragment: trickFragment,
}

export const methods: Shader = {
    vertex: methodVertex,
    fragment: methodFragment,
    texture: './assets/images/galactic-core.webp'
}

export const drawing: Shader = {
    vertex: drawingVertex,
    fragment: drawingFragment,
    texture: './assets/images/galactic-core.webp'
}
