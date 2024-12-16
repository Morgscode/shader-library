import Renderer from "./renderer";
import * as shaders from './shaders';
import './style.css';

window.addEventListener('load', () => {
    if (window.location.search) {
        const search = new URLSearchParams(window.location.search);
        const type = search.get('type') as string;
        const selection = search.get('shader') as string;
        if (type && selection) {
            const app = shaders as shaders.ShaderLibrary;
            const shader = app[type][selection];
            if (shader) {
                const renderer = new Renderer(shader);
                renderer.render();
            }
        }
    }
});

// const shader = shaders["fractals"];
// const renderer = new Renderer(shader);
// renderer.render();

