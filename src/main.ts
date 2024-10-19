import Renderer from "./renderer";
import * as shaders from './shaders/index';
import './style.css';

const shader = shaders["first"];
const shaderRenderer = new Renderer(shader);
shaderRenderer.init();