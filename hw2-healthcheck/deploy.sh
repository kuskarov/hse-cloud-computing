#!/usr/bin/env bash

set -e

echo "Folder name: $FOLDER_NAME"
echo "Yandex OAUTH: $YANDEX_OAUTH"
echo "Yandex CloudID: $CLOUD_ID"
echo "Yandex service account id: $SERVICE_ACCOUNT_ID"
echo "Registry name: $REGISTRY_NAME"

export FOLDER_ID=$(yc resource-manager folder get "$FOLDER_NAME" | head -n 1 | cut -d ' ' -f 2)

echo "Creating registry $REGISTRY_NAME in folder $FOLDER_NAME..."

yc container registry create --folder-name "$FOLDER_NAME" --name "$REGISTRY_NAME"
yc container registry configure-docker
export REGISTRY_ID=$(yc container registry get --folder-name "$FOLDER_NAME" --name "$REGISTRY_NAME" | head -n 1 | cut -d ' ' -f 2)
echo "Registry ID: $REGISTRY_ID"

echo "Building docker images..."

docker build -t cr.yandex/"$REGISTRY_ID"/nginx:1 ./nginx/
docker build -t cr.yandex/"$REGISTRY_ID"/pg:1 ./postgres/
docker build -t cr.yandex/"$REGISTRY_ID"/backend:1 ./backend/

echo "Pushing docker images to registry..."

docker push cr.yandex/"$REGISTRY_ID"/nginx:1
docker push cr.yandex/"$REGISTRY_ID"/pg:1
docker push cr.yandex/"$REGISTRY_ID"/backend:1

echo "Deploying to cloud..."

cd terraform/

envsubst <vars.tf.example >vars.tf
envsubst <nginx.yaml.example >nginx.yaml
envsubst <backend.yaml.example >backend.yaml
envsubst <postgresql.yaml.example >postgresql.yaml

terraform init
terraform apply -auto-approve

echo "Done."
