import { EditorView, basicSetup } from "codemirror"
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
            const path = `/shader.html${window.location.search}`;
            const shaderEl = document.querySelector('div#shader') as HTMLDivElement;
            if (shaderEl) {
                if (shader) {
                    const renderer = new Renderer(shader);
                    renderer.render();
                }
            }

            if (window.location.pathname.startsWith('/entry')) {
                const previewEl = document.querySelector('iframe#shader-preview') as HTMLIFrameElement;
                if (previewEl) {
                    previewEl.src = path;
                }

                const editorEl = document.querySelector('div#editor') as HTMLDivElement;
                if (editorEl) {
                    new EditorView({
                        extensions: [basicSetup],
                        parent: editorEl,
                        doc: shader.fragment,
                    });
                }
    
                const titleEl = document.querySelector('h2#shader-name');
                if (titleEl) {
                    titleEl.textContent = shader.title;
                }

                const linkEl = document.querySelector('a#shader-link') as HTMLAnchorElement;
                if (linkEl) {
                    linkEl.href = path;
                }
            }
        }
    }
});
