import {
    EditorView, basicSetup
} from "codemirror";
import { cpp } from "@codemirror/lang-cpp";
import { dracula } from 'thememirror';
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

            if (window.location.pathname.startsWith('/shader')) {
                const shaderEl = document.querySelector<HTMLDivElement>('div#shader');
                if (shaderEl) {
                    if (shader) {
                        renderer = new Renderer(shader);
                        renderer.render();
                    }
                }
            }

            if (window.location.pathname.startsWith('/entry')) {
                const titleEl = document.querySelector<HTMLHeadingElement>('h2#shader-name');
                if (titleEl) {
                    titleEl.textContent = shader.title;
                }

                const linkEl = document.querySelector<HTMLAnchorElement>('a#shader-link');
                if (linkEl) {
                    linkEl.href = path;
                }

                const previewEl = document.querySelector<HTMLIFrameElement>('iframe#shader-preview');
                if (previewEl) {
                    previewEl.src = path;
                }

                const editorEl = document.querySelector<HTMLDivElement>('div#editor');
                if (editorEl) {
                    const updateListener = EditorView.updateListener.of((update) => {
                        if (update.docChanged && previewEl) {
                            const fragment = update.state.doc.toString();
                            previewEl.contentWindow?.postMessage({
                                type: "ShaderUpdate",
                                fragment,
                            });
                        }
                    });
                    new EditorView({
                        extensions: [basicSetup, dracula, cpp(), updateListener],
                        parent: editorEl,
                        doc: shader.fragment,
                    });
                }
            }
        }
    }
});
