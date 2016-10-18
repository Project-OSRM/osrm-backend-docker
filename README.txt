# Docker recipes for OSRM

The scripts and dockerfiles here are used to produce official OSRM docker images.
The OSRM demo server periodically uses `build-master.sh` to grab the latest `master` code
and publish a new image to DockerHub.

The same Dockerfile can be used for tagged builds.

# Usage

```
./build.sh
```

will build the latest `master` code, and tag the image with `osrm/osrm-backend:master-<gitsha>`

```
./build.sh <tag>
```

will build the specified git tag, and tag the docker image as `osrm/osrm-backend:<tag>`
