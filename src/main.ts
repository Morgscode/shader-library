import {
    EditorView, basicSetup
} from "codemirror";
import { dracula } from 'thememirror';
import { cpp } from "@codemirror/lang-cpp"
import Renderer from "./renderer";
import * as shaders from './shaders';
import './style.css';

let renderer: Renderer | null = null;

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
                    renderer = new Renderer(shader);
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
                    const updateListener = EditorView.updateListener.of((update) => {
                        if (update.docChanged) {
                            if (previewEl) {
                                const fragment = update.state.doc.toString();
                                previewEl.contentWindow?.postMessage({
                                    type: "ShaderUpdate",
                                    fragment,
                                });
                            }
                        }
                    });
                    new EditorView({
                        extensions: [basicSetup, dracula, cpp(), updateListener],
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

            window.addEventListener("message", (e: MessageEvent) => {
                const event = e.data.type;
                if (event === "ShaderUpdate" && renderer instanceof Renderer) {
                    renderer.setFragmentShader(e.data.fragment);
                }
            });
        }
    }
});
