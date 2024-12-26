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
            // standard shader rendering used everywhere
            const shaderEl = document.querySelector('div#shader') as HTMLDivElement;
            if (shaderEl) {
                if (shader) {
                    const renderer = new Renderer(shader);
                    renderer.render();
                }
            }

            // entry page only code
            if (window.location.pathname.startsWith('/entry')) {
                
                const preview = document.querySelector('iframe#shader-preview') as HTMLIFrameElement;
                console.log(preview);
                if (preview) {
                    preview.src = path;
                }

                const editor = document.querySelector('div#editor') as HTMLDivElement;
                console.log(editor);
                if (editor) {
                   
                    new EditorView({
                        extensions: [basicSetup],
                        parent: editor,
                        doc: shader.fragment,
                    });
                     editor.style.height = `calc(100vh - ${preview.style.height})`
                }
    
                const title = document.querySelector('h2#shader-name');
                if (title) {
                    title.textContent = shader.title;
                }

                const link = document.querySelector('a#shader-link') as HTMLAnchorElement;
                if (link) {
                    link.href = path;
                }
            }
        }
    }
});
