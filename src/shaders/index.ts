import firstVertex from './first/vertex.glsl';
import firstFragment from './first/fragment.glsl';
import textureVertex from './textures/vertex.glsl';
import textureFragment from './textures/fragment.glsl';

export type Shader = {
    vertex: string;
    fragment: string;
    texture?: string;
}

export const first: Shader = {
    vertex: firstVertex,
    fragment: firstFragment,
}

export const texture: Shader = {
    vertex: textureVertex,
    fragment: textureFragment,
    texture: './assets/images/galactic-core.webp'
}
