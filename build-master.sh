#!/bin/sh -x

# Get the current HEAD gitsha, and use the first 8 chars as a short reference to it
SHORT_HEAD=$(git ls-remote https://github.com/Project-OSRM/osrm-backend.git HEAD | cut -f 1 | cut -c1-8 )

docker build -t osrm:master-${SHORT_HEAD} --build-arg OSRM_VERSION=${SHORT_HEAD} --build-arg BUILD_TYPE=Release .
docker build -t osrm:master-${SHORT_HEAD}-debug --build-arg OSRM_VERSION=${SHORT_HEAD} --build-arg BUILD_TYPE=Debug .
