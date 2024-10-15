import { defineConfig } from "vite";

export default defineConfig({
  server: {
    watch: {
      // Watch for changes in the shaders
      ignored: ["!**/public/**"],
    },
  },
  build: {
    rollupOptions: {
      input: ["index.html", "shaders.html"],
    },
  },
});
