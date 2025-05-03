import { defineConfig } from "vite";
import glsl from "vite-plugin-glsl";

export default defineConfig({
  server: {
    port: 42069,
  },
  build: {
    rollupOptions: {
      input: [
        "index.html",
        "library-entry.html",
        "shader.html",
      ],
    },
  },
  plugins: [
    glsl({
      include: ["./src/shaders/**/*.glsl"],
      compress: false,
    }),
  ],
});
