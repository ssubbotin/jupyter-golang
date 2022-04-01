#!/bin/bash -e

export GOLANG_VERSION=1.18
docker build -t ssubbotin/jupyter-golang:latest \
             -t ssubbotin/jupyter-golang:${GOLANG_VERSION} \
             --build-arg VERSION=${GOLANG_VERSION} \
             .

docker push ssubbotin/jupyter-golang:latest
docker push ssubbotin/jupyter-golang:${GOLANG_VERSION}