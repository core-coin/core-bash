#!/bin/sh

# Check if Network name is provided
if [ -z "$1" ]
  then
    echo "No Network name provided"
    exit 1
fi

# Download image from github
docker pull docker.pkg.github.com/core-coin/go-core/gocore:latest

containerName="gocore-$1"

# Run container based on downloaded image
docker run -d --name "$containerName" --net=host docker.pkg.github.com/core-coin/go-core/gocore:latest --$1

# Show logs of running node
docker logs -f "$containerName"

exit 0
