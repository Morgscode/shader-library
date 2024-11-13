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
import lightingVertex from './lighting/vertex.glsl';
import lightingFragment from './lighting/fragment.glsl';

export type CameraType = "orthographic" | "perspective";

export type Shader = {
    vertex: string;
    fragment: string;
    cameraType: CameraType;
    texture?: string;
    cubeTexture?: Array<string>;
    model?: string;
}

export const colors: Shader = {
    vertex: colorVertex,
    fragment: colorFragment,
    cameraType: "orthographic"
}

export const textures: Shader = {
    vertex: textureVertex,
    fragment: textureFragment,
    cameraType: "orthographic",
    texture: './assets/images/galactic-core.webp'
}

export const tricks: Shader = {
    vertex: trickVertex,
    fragment: trickFragment,
    cameraType: "orthographic"
}

export const methods: Shader = {
    vertex: methodVertex,
    fragment: methodFragment,
    cameraType: "orthographic",
    texture: './assets/images/galactic-core.webp'
}

export const drawing: Shader = {
    vertex: drawingVertex,
    fragment: drawingFragment,
    cameraType: "orthographic",
    texture: './assets/images/galactic-core.webp'
}

export const lighting: Shader = {
    vertex: lightingVertex,
    fragment: lightingFragment,
    cameraType: "perspective",
    texture: './assets/images/galactic-core.webp',
    cubeTexture: [
        './assets/shader-resources/01/Cold_Sunset__Cam_2_Left+X.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_3_Right-X.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_4_Up+Y.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_5_Down-Y.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_0_Front+Z.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_1_Back-Z.png',
    ],
}
