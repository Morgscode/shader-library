import colorVertex from './colors/fragment.glsl';
import colorFragment from './colors/vertex.glsl';
import textureVertex from './textures/vertex.glsl';
import textureFragment from './textures/fragment.glsl';
import drawingVertex from './drawing/vertex.glsl';
import drawingFragment from './drawing/fragment.glsl';
import lightingVertex from './lighting/vertex.glsl';
import lightingFragment from './lighting/fragment.glsl';
import transformVertex from './vertex-transforms/vertex.glsl';
import transformFragment from './vertex-transforms/fragment.glsl';
import shapeVertex from './shapes/vertex.glsl';
import shapeFragment from './shapes/fragment.glsl';
import fractalVertex from './fractals/vertex.glsl';
import fractalFragment from './fractals/fragment.glsl';
import cloudVertex from './clouds/vertex.glsl';
import cloudFragment from './clouds/fragment.glsl';
import { shaders as librayShaders } from './library';
import { shaders as exampleShaders } from './examples';

export type CameraType = "orthographic" | "perspective";
export type GeometryOption = undefined | "plane" | "box" | "icosahedrone";

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

export type ShaderLibrary = {
    [k: string]: Shader | Record<string, Shader>,
}

export const colors: Shader = {
    vertex: colorVertex,
    fragment: colorFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
    texture: './assets/images/galactic-core.webp'
}

export const textures: Shader = {
    vertex: textureVertex,
    fragment: textureFragment,
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

export const transforms: Shader = {
    vertex: transformVertex,
    fragment: transformFragment,
    cameraType: "perspective",
    geometry: "icosahedrone",
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

export const shapes: Shader = {
    vertex: shapeVertex,
    fragment: shapeFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
}

export const fractals: Shader = {
    vertex: fractalVertex,
    fragment: fractalFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false,
}

export const clouds: Shader = {
    vertex: cloudVertex,
    fragment: cloudFragment,
    cameraType: "orthographic",
    geometry: "plane",
    controls: false
}

export const library = librayShaders;
export const example = exampleShaders;