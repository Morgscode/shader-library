import Renderer from "./renderer";
import * as shaders from './shaders';
import './style.css';

const shader = shaders["methods"];
const shaderRenderer = new Renderer(shader);
shaderRenderer.init();
