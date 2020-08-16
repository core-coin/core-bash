#!/bin/sh

# Set credentials to download image from private rep
# MUST BE REMOVED ON RELEASE WHEN REPO WILL BE NOT PRIVATE
cat ./access_token.txt | docker login https://docker.pkg.github.com/ -u error2215 --password-stdin

# Download image from github
docker pull docker.pkg.github.com/core-coin/go-core/gocore:latest


containerName="gocore-$1"

# Run container based on downloaded image
docker run -d --name "$containerName" --net=host docker.pkg.github.com/core-coin/go-core/gocore:latest --networkid "$1"

# Show logs of running node
docker logs -f "$containerName"