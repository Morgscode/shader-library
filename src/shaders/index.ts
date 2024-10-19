import firstVertex from './first/vertex.glsl';
import firstFragment from './first/fragment.glsl';
import textureVertex from './textures/vertex.glsl';
import textureFragment from  './textures/fragment.glsl';

export const first = {
    vertex: firstVertex,
    fragment: firstFragment,
}

export const textures = {
    vertex: textureVertex,
    fragment: textureFragment
}

