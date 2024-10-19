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

    constructor(shader: Shader) {
        this.app = document.querySelector("#app");
        this.threejs = new THREE.WebGLRenderer();
        this.scene = new THREE.Scene();
        this.camera = new THREE.OrthographicCamera(0, 1, 1, 0, 0.1, 2000);
        this.textureLoader = new THREE.TextureLoader()
        this.vsh = shader.vertex;
        this.fsh = shader.fragment;
    }

    init() {
       if (!this.app) return;
       this.app.appendChild(this.threejs.domElement);
       window.addEventListener('resize', (e) => this.onWindowResize(e));
       this.camera.position.set(0, 0, 1);
       this.shader()
       this.animate();
    }

    shader() {
        const texture = this.textureLoader.load('./assets/images/trippy-ground.png');

        // https://threejs.org/docs/#api/en/materials/ShaderMaterial
        const material = new THREE.ShaderMaterial({
            uniforms: {
                diffuse: {value: texture}
            },
            vertexShader: this.vsh,
            fragmentShader: this.fsh
        });

        // https://threejs.org/docs/#api/en/geometries/PlaneGeometry
        const geometry = new THREE.PlaneGeometry(1, 1);
        const plane = new THREE.Mesh(geometry, material);
        plane.position.set(0.5, 0.5, 0);
        this.scene.add(plane);
        this.onWindowResize(null);
    }

    onWindowResize(_: UIEvent | null) {
        this.threejs.setSize(window.innerWidth, window.innerHeight);
    }

    animate() {
        requestAnimationFrame(() => {
            this.threejs.render(this.scene, this.camera);
            this.animate();
        })
    }

}
