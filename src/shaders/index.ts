import firstVertex from './first/vertex.glsl';
import firstFragment from './first/fragment.glsl';
import textureVertex from './textures/vertex.glsl';
import textureFragment from './textures/fragment.glsl';
import trickVertex from './tricks/vertex.glsl';
import trickFragment from './tricks/fragment.glsl'
import methodVertex from './methods/vertex.glsl';
import methodFragment from './methods/fragment.glsl';

export type Shader = {
    vertex: string;
    fragment: string;
    texture?: string;
}

export const first: Shader = {
    vertex: firstVertex,
    fragment: firstFragment,
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
