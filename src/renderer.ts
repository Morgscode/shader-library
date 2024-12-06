import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/Addons.js";
import type { Shader, CameraType } from "./shaders";

export default class Renderer {

    private htmlDomElement: HTMLElement | null;
    private threejs: THREE.WebGLRenderer;
    private scene: THREE.Scene;
    private camera: THREE.OrthographicCamera | THREE.PerspectiveCamera;
    private material: THREE.ShaderMaterial;
    private gltfLoader: GLTFLoader
    private textureLoader: THREE.TextureLoader;
    private cubeTextureLoader: THREE.CubeTextureLoader;
    private vsh: string;
    private fsh: string;
    private lastFrameTime: DOMHighResTimeStamp;
    private elapsedTime: number;
    private uniforms: Record<string, THREE.Uniform>;
    private texture?: string | THREE.Texture;
    private cubeTexture?: Array<string> | THREE.CubeTexture;
    private model?: string;

    constructor(shader: Shader, selector: string = "#app") {
        this.htmlDomElement = document.querySelector(selector);
        this.threejs = new THREE.WebGLRenderer();
        this.scene = new THREE.Scene();
        this.camera = this.initCamera(shader.cameraType);
        this.material = new THREE.ShaderMaterial();
        this.textureLoader = new THREE.TextureLoader();
        this.cubeTextureLoader = new THREE.CubeTextureLoader();
        this.gltfLoader = new GLTFLoader();
        this.vsh = shader.vertex;
        this.fsh = shader.fragment;
        this.texture = shader.texture;
        this.cubeTexture = shader.cubeTexture;
        this.model = shader.model;
        this.lastFrameTime = performance.now();
        this.elapsedTime = 0;
        this.uniforms = this.initUniforms();
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

    render() {
        if (!this.htmlDomElement) throw new Error('Renderer initiated without a DOM Element');
        this.htmlDomElement.appendChild(this.threejs.domElement);
        window.addEventListener('resize', (e) => this.resize(e));
        this.initShader();
        this.animate();
    }

    resize(_: UIEvent | null) {
        this.material && this.material.uniforms.u_resolution.value.set(window.innerWidth, window.innerHeight);
        this.threejs.setSize(window.innerWidth, window.innerHeight);
    }

    protected initUniforms() {
        return {
            u_resolution: new THREE.Uniform(new THREE.Vector2(window.innerWidth, window.innerHeight)),
            u_diffuse: this.texture ? new THREE.Uniform(this.loadTexture()) : new THREE.Uniform(new THREE.Vector4(0.0, 0.0, 0.0, 1.0)),
            u_time: new THREE.Uniform(0.0),
            u_tint: new THREE.Uniform(new THREE.Vector4(0.0, 1.0, 1.0, 1.0))
        };
    }

    protected initCamera(cameraType: CameraType) {
        if (cameraType === "perspective") {
            const camera = new THREE.PerspectiveCamera(60, 1920.0 / 1080.0, 0.1, 1000.0);
            camera.position.set(1, 0, 3);
            return camera;
        }
        const camera = new THREE.OrthographicCamera(0, 1, 1, 0, 0.1, 1000);
        camera.position.set(0, 0, 1);
        return camera;
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
            this.loadCubeTexture();
        }

        if (this.model) {
            this.loadModel();
        }

        this.resize(null);
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

    protected loadCubeTexture(magFilter: THREE.MagnificationTextureFilter = THREE.LinearFilter) {
        if (!this.cubeTexture) throw new Error('Tried to load an undefined cube texture')
        this.cubeTexture = this.cubeTextureLoader.load(this.cubeTexture as Array<string>);
        this.cubeTexture.magFilter = magFilter;
        this.scene.background = this.cubeTexture;
        return this.cubeTexture;
    }

    protected loadModel() {
        if (!this.model) throw new Error("Tried to load an undefined model");
        this.gltfLoader.load(this.model, (gltf) => {
            gltf.scene.traverse(c => {
                c.material = this.material
            });
            this.scene.add(gltf.scene);
        });
    }

}
