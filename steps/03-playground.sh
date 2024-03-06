#!/bin/bash
set -eu
# Create a playground app for testing the library
mkdir playground
cd playground
jq -n '{type: "module", scripts: {dev: "vite"}}' >package.json
cat >index.html <<"EOF"
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Playground</title>
        <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    </head>
    <body>
        <div id="app"></div>
        <script type="module" src="/src/main.ts"></script>
    </body>
</html>
EOF
mkdir src
cat >src/main.ts <<"EOF"
import hello from 'hello-lib'

document.querySelector<HTMLDivElement>('#app')!.innerHTML = `
<p>${hello('world')}</p>
`
EOF
pnpm add -D typescript vite
pnpm link ..
pnpm dev
