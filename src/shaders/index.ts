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
import vertexVertex from './vertex/vertex.glsl';
import vertexFragment from './vertex/fragment.glsl';

export type CameraType = "orthographic" | "perspective";
export type GeometryOption = undefined | "plane" | "box";

export type Shader = {
    vertex: string;
    fragment: string;
    cameraType: CameraType;
    geometry: false | GeometryOption;
    controls: boolean;
    texture?: string;
    cubeTexture?: Array<string>;
    model?: string;
}

export const colors: Shader = {
    vertex: colorVertex,
    fragment: colorFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
}

export const textures: Shader = {
    vertex: textureVertex,
    fragment: textureFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
    texture: './assets/images/galactic-core.webp'
}

export const tricks: Shader = {
    vertex: trickVertex,
    fragment: trickFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
}

export const methods: Shader = {
    vertex: methodVertex,
    fragment: methodFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
    texture: './assets/images/galactic-core.webp'
}

export const drawing: Shader = {
    vertex: drawingVertex,
    fragment: drawingFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
    texture: './assets/images/galactic-core.webp'
}

export const lighting: Shader = {
    vertex: lightingVertex,
    fragment: lightingFragment,
    cameraType: "perspective",
    geometry: false,
    controls: true,
    texture: './assets/images/galactic-core.webp',
    cubeTexture: [
        './assets/shader-resources/01/Cold_Sunset__Cam_2_Left+X.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_3_Right-X.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_4_Up+Y.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_5_Down-Y.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_0_Front+Z.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_1_Back-Z.png',
    ],
    model: './assets/shader-resources/01/suzanne.glb'
}

export const vertex: Shader = {
    vertex: vertexVertex,
    fragment: vertexFragment,
    cameraType: "perspective",
    geometry: "box",
    controls: true,
    cubeTexture: [
        './assets/shader-resources/01/Cold_Sunset__Cam_2_Left+X.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_3_Right-X.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_4_Up+Y.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_5_Down-Y.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_0_Front+Z.png',
        './assets/shader-resources/01/Cold_Sunset__Cam_1_Back-Z.png',
    ],
}
