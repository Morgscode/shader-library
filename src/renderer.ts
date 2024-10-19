import * as THREE from "three";
import type { Shader } from "./shaders";

export default class Renderer {

    _threejs: THREE.WebGLRenderer;
    _scene: THREE.Scene;
    _camera: THREE.Camera;
    _textureLoader: THREE.TextureLoader;
    _vsh: string;
    _fsh: string;
    _app: HTMLDivElement | null;

    constructor(shader: Shader) {
        this._app = document.querySelector("#app");
        this._threejs = new THREE.WebGLRenderer();
        this._scene = new THREE.Scene();
        this._camera = new THREE.OrthographicCamera(0, 1, 1, 0, 0.1, 2000);
        this._textureLoader = new THREE.TextureLoader()
        this._vsh = shader.vertex;
        this._fsh = shader.fragment;
    }

    async init() {
       if (!this._app) return;
       this._app.appendChild(this._threejs.domElement);
       window.addEventListener('resize', (e) => this._onWindowResize(e));
       this._camera.position.set(0, 0, 1);
       await this.shader()
       this._raf();
    }

    async shader() {
        const texture = this._textureLoader.load('./assets/images/trippy-ground.png');

        // https://threejs.org/docs/#api/en/materials/ShaderMaterial
        const material = new THREE.ShaderMaterial({
            uniforms: {
                diffuse: {value: texture}
            },
            vertexShader: this._vsh,
            fragmentShader: this._fsh
        });

        // https://threejs.org/docs/#api/en/geometries/PlaneGeometry
        const geometry = new THREE.PlaneGeometry(1, 1);
        const plane = new THREE.Mesh(geometry, material);
        plane.position.set(0.5, 0.5, 0);
        this._scene.add(plane);
        this._onWindowResize(null);
    }

    _onWindowResize(_: UIEvent | null) {
        this._threejs.setSize(window.innerWidth, window.innerHeight);
    }

    _raf() {
        requestAnimationFrame((_) => {
            this._threejs.render(this._scene, this._camera);
            this._raf();
        })
    }

}
