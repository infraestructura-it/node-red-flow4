#!/bin/bash

# Nombre del repositorio
REPO="node-red-flow3"

# Crear carpeta base
mkdir "$REPO" && cd "$REPO"

# Crear estructura de carpetas
mkdir -p .devcontainer
mkdir -p .github/workflows

# Crear docker-compose.yml
cat <<EOF > docker-compose.yml
version: "3.8"

services:
  nodered:
    image: nodered/node-red:latest
    container_name: nodered
    ports:
      - "1880:1880"
    volumes:
      - nodered_data:/data

volumes:
  nodered_data:
EOF

# Crear devcontainer.json
cat <<EOF > .devcontainer/devcontainer.json
{
  "name": "Node-RED Dev",
  "dockerComposeFile": "../docker-compose.yml",
  "service": "nodered",
  "workspaceFolder": "/workspace",
  "shutdownAction": "stopCompose"
}
EOF

# Crear workflow de GitHub Actions
cat <<EOF > .github/workflows/main.yml
name: CI - Node-RED

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Clonar repo
        uses: actions/checkout@v3

      - name: Levantar servicios con Docker Compose
        run: docker-compose up -d

      - name: Verificar ejecución
        run: docker ps -a
EOF

# Crear README
echo "# Node-RED Flow 3" > README.md

# Inicializar Git y primer commit
git init
git add .
git commit -m "Inicializando node-red-flow3 con soporte Codespaces y docker-compose"

echo "✅ Proyecto '$REPO' creado. Ahora puedes hacer 'git remote add origin <url>' y 'git push -u origin main'"