#!/bin/bash
set -e
REG=$DOCKER_REGISTRY
REG_USER=$DOCKER_REGISTRY_USER
REG_PW=$DOCKER_REGISTRY_PASSWORD
echo "registry: $REG / user: $REG_USER"

mkdir -p auth
AUTH=$(echo -n "${REG_USER}:${REG_PW}" | base64)
cat > auth/config.json <<EOF
{ "auths": { "${REG}": { "auth": "${AUTH}" } } }
EOF

docker run --rm \
  -v "$(pwd)":/workspace \
  -v "$(pwd)/auth/config.json":/kaniko/.docker/config.json \
  gcr.io/kaniko-project/executor:latest \
  --dockerfile=/workspace/Dockerfile \
  --context=dir:///workspace \
  --destination=${REG}/class-4/sk0129-myfirst-api-server:1.0.kaniko \
  --custom-platform=linux/amd64
