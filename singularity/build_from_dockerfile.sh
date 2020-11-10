#!/usr/bin/env bash

set -e
# This script documents how to build the singularity container
# from the Dockerfile

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Must run script with sudo or as root"
    exit
fi

# exit on errors
trap 'exit' ERR

# build docker container
docker build -t matlab-octave .

# docker registry server to host docker image locally
# do nothing if running, otherwise try to start registry or create registry
[[ $(docker inspect -f '{{.State.Running}}' registry) == "true" ]] \
  || docker container start registry \
  || docker run -d -p 5000:5000 --restart=always --name registry registry:2

# push image to local registry
docker tag matlab-octave:latest localhost:5000/matlab-octave
docker push localhost:5000/matlab-octave

# create a temporary singularity def file
declare -r TMPFILE="$(mktemp --suffix 'singularity.def')"
cat > "$TMPFILE" << EOI
Bootstrap: docker
Registry: localhost:5000
Namespace:
From: matlab-octave:latest
EOI
# build singularity image
sudo SINGULARITY_NOHTTPS=1 singularity build singularity/matlab-octave.sif "$TMPFILE"

# remove temp file
rm -f "$TMPFILE"

# stop registry server
docker container stop registry
