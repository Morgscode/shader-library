import Renderer from "./renderer";
import * as shaders from './shaders';
import './style.css';

const shader = shaders["shapes"];
const renderer = new Renderer(shader);
renderer.render();
