import Renderer from "./renderer";
import './style.css';
import * as shaders from './shaders/index';

const shader = shaders["textures"];

const shaderRenderer = new Renderer(shader.vertex, shader.fragment);
shaderRenderer.init();