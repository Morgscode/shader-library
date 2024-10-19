import * as THREE from "three";
import type { Shader } from "./shaders";

export default class Renderer {

    threejs: THREE.WebGLRenderer;
    scene: THREE.Scene;
    camera: THREE.Camera;
    textureLoader: THREE.TextureLoader;
    vsh: string;
    fsh: string;
    app: HTMLDivElement | null;
    material?: THREE.ShaderMaterial;
    texture?: string;

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

    init() {
       if (!this.app) throw new Error('Renderer initiated without a DOM Element');
       this.app.appendChild(this.threejs.domElement);
       window.addEventListener('resize', (e) => this.onWindowResize(e));
       this.camera.position.set(0, 0, 1);
       this.shader();
       this.animate();
    }

    shader() {
        // https://threejs.org/docs/#api/en/materials/ShaderMaterial
        this.material = new THREE.ShaderMaterial({
            uniforms: {
                u_resolution:  new THREE.Uniform( new THREE.Vector2(window.innerWidth, window.innerHeight) ),
                u_diffuse: new THREE.Uniform(  this.loadTexture() )
            },
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

    onWindowResize(_: UIEvent | null) {
        this.material && this.material.uniforms.u_resolution.value.set(window.innerWidth, window.innerHeight);
        this.threejs.setSize(window.innerWidth, window.innerHeight);
    }

    animate() {
        requestAnimationFrame(() => {
            this.threejs.render(this.scene, this.camera);
            this.animate();
        })
    }

    loadTexture() {
        return this.textureLoader.load('./assets/images/trippy-ground.png');
    }
}
