#!/bin/sh

# Check if Network name is provided
if [ -z "$1" ]
  then
    echo "No Network name provided"
    exit 1
fi
# Check if Account password is provided
if [ -z "$2" ]
  then
    echo "No Account password provided"
    exit 2
fi
# Check if Number of threads is provided
if [ -z "$3" ]
  then
    echo "No number of threads provided"
    exit 3
fi

# Download image from github
docker pull docker.pkg.github.com/core-coin/go-core/gocore:latest

# Docker contaniner name
containerName="gocore-$1"
# Gocore account password
accountPass=$2
# Miner threads
minerThreads=$3

# Run container based on downloaded image
docker run -d --name "$containerName" --net=host docker.pkg.github.com/core-coin/go-core/gocore:latest --$1 --nat=auto
sleep 2
# Create account and start mining
docker exec -it "$containerName" gocore --exec "personal.newAccount(\"$accountPass\"); miner.start($minerThreads)" attach ~/.$1/gocore.ipc
# Show logs of running node
docker logs -f "$containerName"

exit 0
