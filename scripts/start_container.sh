#!/bin/bash
set -e

APP_DIR="/home/ec2-user/app"

# If you store .env in SSM Parameter Store, fetch it (see below) before trying to use it.
# Example: fetch secure parameter named "/myapp/prod/.env" and write to $APP_DIR/.env
# aws ssm get-parameter --name "/myapp/prod/.env" --with-decryption --query "Parameter.Value" --output text > $APP_DIR/.env || true

# Read image URI from imagedefinitions.json
IMAGE_URI=$(jq -r '.[0].imageUri' $APP_DIR/imagedefinitions.json)

# Stop and remove existing container if any
docker rm -f view_api || true

# Pull latest image and run
docker pull "$IMAGE_URI"
# run container (adjust --env-file if you have .env)
docker run -d --restart unless-stopped --name view_api -p 4000:4000 --env-file "$APP_DIR/.env" "$IMAGE_URI"
