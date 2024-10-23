import * as THREE from "three";
import type { Shader } from "./shaders";

export default class Renderer {

    private htmlDomElement: HTMLElement | null;
    private threejs: THREE.WebGLRenderer;
    private scene: THREE.Scene;
    private camera: THREE.Camera;
    private textureLoader: THREE.TextureLoader;
    private material: THREE.ShaderMaterial;
    private vsh: string;
    private fsh: string;
    private startTime: DOMHighResTimeStamp;
    private uniforms: Record<string, THREE.Uniform>;
    private texture?: string | THREE.Texture;

    constructor(shader: Shader, selector: string = "#app") {
        this.htmlDomElement = document.querySelector(selector);
        this.threejs = new THREE.WebGLRenderer();
        this.scene = new THREE.Scene();
        this.camera = new THREE.OrthographicCamera(0, 1, 1, 0, 0.1, 2000);
        this.textureLoader = new THREE.TextureLoader();
        this.material = new THREE.ShaderMaterial();
        this.vsh = shader.vertex;
        this.fsh = shader.fragment;
        this.startTime = performance.now();
        this.texture = shader.texture;
        this.uniforms = this._initUniforms();
    }

    getHtmlDomElement() {
        return this.htmlDomElement;
    }

    setHtmlDomElement(htmlDivEl: HTMLDivElement) {
        this.htmlDomElement = htmlDivEl;
    }

    getTexture() {
        return this.texture;
    }

    setTexture(texture: string) {
        this.texture = texture
    }

    getUniforms() {
        return this.uniforms;
    }

    setUniforms(uniforms: Record<string, THREE.Uniform>) {
        this.uniforms = uniforms;
    }

    getUniform(key: string) {
        return this.uniforms[key];
    }

    setUniform(key: string, value: THREE.Uniform) {
        this.uniforms[key] = value
    }

    init() {
        if (!this.htmlDomElement) throw new Error('Renderer initiated without a DOM Element');
        this.htmlDomElement.appendChild(this.threejs.domElement);
        window.addEventListener('resize', (e) => this.onWindowResize(e));
        this.camera.position.set(0, 0, 1);
        this.shader();
        this.animate();
    }

    protected _initUniforms() {
        return {
            u_resolution: new THREE.Uniform(new THREE.Vector2(window.innerWidth, window.innerHeight)),
            u_diffuse: this.texture ? new THREE.Uniform(this.loadTexture()) : new THREE.Uniform(new THREE.Vector4(0.0, 0.0, 0.0, 1.0)),
            u_time: new THREE.Uniform(0.0),
            u_tint: new THREE.Uniform(new THREE.Vector4(0.0, 1.0, 1.0, 1.0))
        };
    }

    protected shader() {
        // https://threejs.org/docs/#api/en/materials/ShaderMaterial
        this.material.uniforms = this.getUniforms();
        this.material.vertexShader = this.vsh;
        this.material.fragmentShader = this.fsh;
        // https://threejs.org/docs/#api/en/geometries/PlaneGeometry
        const geometry = new THREE.PlaneGeometry(1, 1);
        const plane = new THREE.Mesh(geometry, this.material);
        plane.position.set(0.5, 0.5, 0);
        this.scene.add(plane);
        this.onWindowResize(null);
    }

    protected animate() {
        requestAnimationFrame(() => {
            const elapsed = performance.now() - this.startTime
            this.material.uniforms.u_time.value = elapsed;
            this.threejs.render(this.scene, this.camera);
            this.animate();
        });
    }

    protected loadTexture(magFilter: THREE.MagnificationTextureFilter = THREE.LinearFilter) {
        if (!this.texture) throw new Error('Tried to load an undefined texture')
        this.texture = this.textureLoader.load(this.texture as string);
        this.texture.magFilter = magFilter;
        return this.texture;
    }

    protected onWindowResize(_: UIEvent | null) {
        this.material && this.material.uniforms.u_resolution.value.set(new THREE.Vector2(window.innerWidth, window.innerHeight));
        this.threejs.setSize(window.innerWidth, window.innerHeight);
    }
}
