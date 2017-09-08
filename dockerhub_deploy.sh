#!/bin/bash

echo 'Dockerhub login...'
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"

echo 'Dockerhub push...'
docker push michaelvanvliet/container-data-analysis:latest
echo 'Finished!'