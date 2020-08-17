#!/bin/sh

# Set credentials to download image from private rep
# MUST BE REMOVED ON RELEASE WHEN REPO WILL BE NOT PRIVATE
cat ./access_token.txt | docker login https://docker.pkg.github.com/ -u error2215 --password-stdin

# Download image from github
docker pull docker.pkg.github.com/core-coin/go-core/gocore:latest

# Docker contaniner name
containerName="gocore-$1"
# Gocore account password
accountPass=$2
# Miner threads
minerThreads=$3

# Run container based on downloaded image
docker run -d --name "$containerName" --net=host docker.pkg.github.com/core-coin/go-core/gocore:latest --networkid "$1"
sleep 2
# Create account and start mining
docker exec -it "$containerName" gocore --exec "personal.newAccount(\"$accountPass\"); miner.start($minerThreads)" attach /testdata/gocore.ipc
# Show logs of running node
docker logs -f "$containerName"