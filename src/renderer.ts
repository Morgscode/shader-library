import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/Addons.js";
import type { Shader, CameraType } from "./shaders";

export default class Renderer {

    private htmlDomElement: HTMLElement | null;
    private threejs: THREE.WebGLRenderer;
    private scene: THREE.Scene;
    private camera: THREE.Camera | THREE.OrthographicCamera | THREE.PerspectiveCamera;
    private cameraType: CameraType;
    private textureLoader: THREE.TextureLoader;
    private cubeTextureLoader: THREE.CubeTextureLoader;
    private material: THREE.ShaderMaterial;
    private vsh: string;
    private fsh: string;
    private lastFrameTime: DOMHighResTimeStamp;
    private elapsedTime: number;
    private uniforms: Record<string, THREE.Uniform>;
    private texture?: string | THREE.Texture;
    private cubeTexture?: Array<string> | THREE.CubeTexture;

    constructor(shader: Shader, selector: string = "#app") {
        this.htmlDomElement = document.querySelector(selector);
        this.threejs = new THREE.WebGLRenderer();
        this.scene = new THREE.Scene();
        this.camera = new THREE.Camera();
        this.cameraType = shader.cameraType;
        this.textureLoader = new THREE.TextureLoader();
        this.cubeTextureLoader = new THREE.CubeTextureLoader();
        this.material = new THREE.ShaderMaterial();
        this.vsh = shader.vertex;
        this.fsh = shader.fragment;
        this.texture = shader.texture;
        this.cubeTexture = shader.cubeTexture;
        this.lastFrameTime = performance.now();
        this.elapsedTime = 0;
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
        this.uniforms[key] = value;
    }

    init() {
        if (!this.htmlDomElement) throw new Error('Renderer initiated without a DOM Element');
        this.htmlDomElement.appendChild(this.threejs.domElement);
        window.addEventListener('resize', (e) => this.onWindowResize(e));
        this.initCamera();
        this.initShader();
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

    protected initCamera() {
        if (this.cameraType === "orthographic") {
            this.camera = new THREE.OrthographicCamera(0, 1, 1, 0, 0.1, 1000);
            this.camera.position.set(0, 0, 1);
        } else if (this.cameraType === "perspective") {
            this.camera = new THREE.PerspectiveCamera(60, 1920.0 / 1080.0, 0.1, 1000.0);
            this.camera.position.set(1, 0, 3);
        }
    }

    protected initShader() {
        // https://threejs.org/docs/#api/en/materials/ShaderMaterial
        this.material.uniforms = this.getUniforms();
        this.material.vertexShader = this.vsh;
        this.material.fragmentShader = this.fsh;

        // https://threejs.org/docs/#api/en/geometries/PlaneGeometry
        const geometry = new THREE.PlaneGeometry(1, 1);
        const plane = new THREE.Mesh(geometry, this.material);
        plane.position.set(0.5, 0.5, 0);
        this.scene.add(plane);

        if (this.cubeTexture) {
            this.cubeTexture = this.cubeTextureLoader.load(this.cubeTexture as Array<string>);
            this.scene.background = this.cubeTexture;
        }

        this.onWindowResize(null);
    }

    protected animate() {
        requestAnimationFrame(() => {
            const currentTime = performance.now();
            const deltaTime = (currentTime - this.lastFrameTime) / 1000;
            this.lastFrameTime = currentTime;
            this.elapsedTime += deltaTime;
            this.material.uniforms.u_time.value = this.elapsedTime;
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
        this.material && this.material.uniforms.u_resolution.value.set(window.innerWidth, window.innerHeight);
        this.threejs.setSize(window.innerWidth, window.innerHeight);
    }

}
