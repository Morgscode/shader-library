import Renderer from "./renderer";
import './style.css';

const shaders = {
    'first': {
        vertex: "first/vertex.glsl",
        fragment: "first/fragment.glsl"
    }
}

const shader = shaders['first'];

const shaderRenderer = new Renderer(shader.vertex, shader.fragment);
shaderRenderer.init();