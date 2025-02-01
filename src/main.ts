import {
    EditorView, basicSetup
} from "codemirror";
import { cpp } from "@codemirror/lang-cpp";
import { dracula } from 'thememirror';
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
            const path = `/shader${window.location.search}`;

            if (window.location.pathname.startsWith('/shader')) {
                const shaderEl = document.querySelector<HTMLDivElement>('div#shader');
                if (shaderEl && shader) {
                    const renderer = new Renderer(shader);
                    renderer.render();
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

window.addEventListener("DOMContentLoaded", () => {
    const search = document.querySelector<HTMLFormElement>("form#search-form");
    if (search) {
        search.addEventListener("submit", (e) => {
            e.preventDefault();
            const results = document.querySelector<HTMLDivElement>("#search-results");
            if (!results) return;
            results.innerHTML = "";
            const data = new FormData(e.target as HTMLFormElement);
            const query = data.get('query') as string;
            const library = shaders["library"];
            const keys = Object.keys(library);
            const matches = keys.filter(key => query && key.includes(query.trim()));
            const list = document.createElement('ul');
            const links = matches.map((match) => shaderSearchResult(match));
            list.innerHTML = links.join("");
            results.appendChild(list);
        });
    }

    const pagination = document.querySelector('nav#pagination');
    if (pagination) {
        const pages = Math.ceil(Object.keys(shaders["library"]).length / 6);
        const links = [];
        for (let i = 0; i < pages; i++) {
            links[i] = paginationItem(i + 1);
        }
        const list = document.createElement('ul');
        list.innerHTML = links.join("");
        pagination.appendChild(list);
    }
});

function shaderSearchResult(key: string) {
    const shader = shaders["library"][key];
    return `<li>
                <span>${shader.title} - </span>
                    <a href="/shader.html?type=library&shader=${key}">Shader</a>
                    &nbsp;|&nbsp;
                    <a href="/entry.html?type=library&shader=${key}">Entry</a>
            </li>`;
}

function paginationItem(page: number) {
    return `<li><a href="/?page=${page}">${page}</a></li>`;
}
