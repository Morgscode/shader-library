import Renderer from "./renderer";
import * as shaders from './shaders';
import './style.css';

window.addEventListener('load', () => {
    if (window.location.search) {
        const search = new URLSearchParams(window.location.search);
        const type = search.get('type');
        const selection = search.get('shader');
        if (type && selection) {
            const app = shaders as shaders.ShaderLibrary;
            const shader = (app[type] as Record<string, shaders.Shader>)[selection];
            if (shader) {
                const renderer = new Renderer(shader);
                renderer.render();
            }
        }
    }
});

const shader = shaders["clouds"];
const renderer = new Renderer(shader);
renderer.render();

