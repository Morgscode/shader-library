import Renderer from "./renderer";
import * as shaders from './shaders';
import './style.css';

const shader = shaders["textures"];
const shaderRenderer = new Renderer(shader);
shaderRenderer.init();
