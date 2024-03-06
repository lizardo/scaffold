#!/bin/bash
set -eu
# Configure base minimum TypeScript support
echo node_modules >.gitignore
mkdir src
cat >src/index.ts <<"EOF"
export default function hello(name: string): string {
    return `Hello, ${name}!`
}
EOF
jq -n '{include: ["src"]}' >tsconfig.json
jq -n '{scripts: {build: "tsc --noEmit"}}' >package.json
pnpm add -D typescript
pnpm build
