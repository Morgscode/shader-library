import { shaders as libraryShaders } from './library';

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

export const library = libraryShaders;