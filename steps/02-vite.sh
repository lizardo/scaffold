#!/bin/bash
set -eu
# Add bare minimum configuration for ViteJS library
echo dist >> .gitignore
cat > vite.config.ts << "EOF"
import { defineConfig } from 'vite'

export default defineConfig({
    build: {
        lib: {
            entry: 'src/index.ts',
            name: 'HelloLib'
        }
    }
})
EOF
jq_inplace '. + {name: "hello-lib", type: "module", exports: "./dist/hello-lib.js", scripts: {build: "vite build"}}' package.json
pnpm add -D vite
pnpm build