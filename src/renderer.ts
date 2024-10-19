import * as THREE from "three";
import type { Shader } from "./shaders";

export default class Renderer {

    private threejs: THREE.WebGLRenderer;
    private scene: THREE.Scene;
    private camera: THREE.Camera;
    private textureLoader: THREE.TextureLoader;
    private vsh: string;
    private fsh: string;
    private app: HTMLDivElement | null;
    private material?: THREE.ShaderMaterial;
    private texture?: string;

    constructor(shader: Shader, selector: string = "#app") {
        this.app = document.querySelector(selector);
        this.threejs = new THREE.WebGLRenderer();
        this.scene = new THREE.Scene();
        this.camera = new THREE.OrthographicCamera(0, 1, 1, 0, 0.1, 2000);
        this.textureLoader = new THREE.TextureLoader();
        this.vsh = shader.vertex;
        this.fsh = shader.fragment;
        this.texture = shader.texture;
    }

    getApp() {
        return this.app;
    }

    setApp(htmlDivEl: HTMLDivElement) {
        this.app = htmlDivEl;
    }

    getTexture() {
        return this.texture;
    }

    setTexture(texture: string) {
        this.texture = texture
    }

    init() {
        if (!this.app) throw new Error('Renderer initiated without a DOM Element');
        this.app.appendChild(this.threejs.domElement);
        window.addEventListener('resize', (e) => this.onWindowResize(e));
        this.camera.position.set(0, 0, 1);
        this.shader();
        this.animate();
    }

    private shader() {
        // https://threejs.org/docs/#api/en/materials/ShaderMaterial

        this.material = new THREE.ShaderMaterial({
            uniforms: this.uniforms(),
            vertexShader: this.vsh,
            fragmentShader: this.fsh
        });

        // https://threejs.org/docs/#api/en/geometries/PlaneGeometry
        const geometry = new THREE.PlaneGeometry(1, 1);
        const plane = new THREE.Mesh(geometry, this.material);
        plane.position.set(0.5, 0.5, 0);
        this.scene.add(plane);
        this.onWindowResize(null);
    }

    private uniforms() {
        return {
            u_resolution: new THREE.Uniform(new THREE.Vector2(window.innerWidth, window.innerHeight)),
            u_diffuse: this.texture ? new THREE.Uniform(this.loadTexture()) : new THREE.Uniform(null)
        }
    }

    private animate() {
        requestAnimationFrame(() => {
            this.threejs.render(this.scene, this.camera);
            this.animate();
        })
    }

    private loadTexture() {
        if (!this.texture) throw new Error('Tried to load an undefined texture')
        return this.textureLoader.load(this.texture);
    }

    private onWindowResize(_: UIEvent | null) {
        this.material && this.material.uniforms.u_resolution.value.set(window.innerWidth, window.innerHeight);
        this.threejs.setSize(window.innerWidth, window.innerHeight);
    }
}
