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
                shaderPage(shader);
            }

            if (window.location.pathname.startsWith('/library-entry')) {
                libraryEntryPage(shader, path);
            }
        }
    }
});

window.addEventListener("DOMContentLoaded", () => {
    const searchForm = document.querySelector<HTMLFormElement>("form#search-form");
    if (searchForm) {
        searchForm.addEventListener("submit", (e) => {
            e.preventDefault();
            const data = new FormData(e.target as HTMLFormElement);
            const query = data.get('query') as string;
            performSearch(query);
        });
    }

    const pagination = document.querySelector<HTMLElement>('nav#pagination');
    if (pagination) {
        buildPagination(pagination);
    }

    if (window.location.search) {
        const search = new URLSearchParams(window.location.search);
        const page = parseInt(search.get('page') ?? "0");
        const list = document.querySelector<HTMLUListElement>('ul#shader-list');
        if (page && list) {
            paginateShaderList(page, list);
        }
    }
});

function buildPagination(pagination: HTMLElement) {
    const pages = Math.ceil(Object.keys(shaders["library"]).length / 6);
    const links = [];
    for (let i = 0; i < pages; i++) {
        links[i] = paginationItem(i + 1);
    }
    const list = document.createElement('ul');
    list.innerHTML = links.join("");
    pagination.appendChild(list);
}

function performSearch(query: string) {
    const results = document.querySelector<HTMLDivElement>("#search-results");
    if (!results) return;
    results.innerHTML = "";
    const library = shaders["library"];
    const keys = Object.keys(library);
    const matches = keys.filter(key => query && key.toLowerCase().includes(query.toLowerCase().trim()));
    const list = document.createElement('ul');
    const links = matches.map((match) => shaderSearchResult(match));
    list.innerHTML = links.join("");
    results!.appendChild(list);
}

function paginateShaderList(page: number, list: HTMLUListElement) {
    const pageSize = 6;
    const pages = Math.ceil(Object.keys(shaders["library"]).length / pageSize);
    const startIndex = (page - 1) * pageSize;
    if (page < 1 || page > pages) return;
    const library = Object.entries(shaders["library"]).reverse();
    const selection = library.slice(startIndex, startIndex + pageSize);
    list.innerHTML = "";
    selection.forEach(item => {
        const shader = shaderListItem(item);
        shader && list.append(shader);
    });
}

function shaderListItem(entry: [string, shaders.Shader]) {
    const [key, shader] = entry;
    if (shader.hidden) return false;

    const li = document.createElement('li');
    const markup = `
        <iframe
            title="${shader.title}"
            src="/shader?type=library&shader=${key}"
            frameborder="0"
            class="${shader.previewAspectRatio}"
        ></iframe>
        <a href="/shader?type=library&shader=${key}"
        >${shader.title}</a>
        |
        <a href="/library-entry?type=library&shader=${key}"
        >Explore/Edit</a>
    `;
    li.innerHTML = markup;
    return li;
}

function shaderSearchResult(key: string) {
    const shader = shaders["library"][key];
    return `<li>
                <span>${shader.title} - </span>
                <a href="/shader.html?type=library&shader=${key}">Shader</a>
                &nbsp;|&nbsp;
                <a href="/library-entry.html?type=library&shader=${key}">Entry</a>
            </li>`;
}

function paginationItem(page: number) {
    return `<li><a href="/?page=${page}">${page}</a></li>`;
}

function shaderPage(shader: shaders.Shader) {
    const shaderEl = document.querySelector<HTMLDivElement>('div#shader');
    if (shaderEl && shader) {
        const renderer = new Renderer(shader);
        renderer.render();
    }
}

function libraryEntryPage(shader: shaders.Shader, path: string,) {
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
        previewEl.classList.add(shader.previewAspectRatio);
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
