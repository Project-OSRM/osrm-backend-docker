# OSRM processing tools, server and profile

FROM alpine:3.4

# This can be a gitsha, tag, or branch - anything that works with `git checkout`
ARG OSRM_VERSION

# This is passed to cmake for osrm-backend.  All other dependencies are built in
# release mode.
ARG BUILD_TYPE=Release

RUN mkdir /opt
WORKDIR /opt
RUN NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add git cmake wget make libc-dev gcc g++ bzip2-dev boost-dev zlib-dev expat-dev lua5.1-dev libtbb@testing libtbb-dev@testing && \
    \
    echo "Building libstxxl" && \
    cd /opt && \
    git clone --depth 1 --branch 1.4.1 https://github.com/stxxl/stxxl.git && \
    cd stxxl && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j${NPROC} && \
    make install && \
    \
    echo "Building OSRM ${OSRM_VERSION}" &&\
    cd /opt && \
    git clone https://github.com/Project-OSRM/osrm-backend.git && \
    cd osrm-backend && \
    git checkout ${OSRM_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} .. && \
    make -j${NPROC} install && \
    cd ../profiles && \
    cp -r * /opt && \
    \
    echo "Cleaning up" && \
    strip /usr/local/bin/* && \
    rm /usr/local/lib/libstxxl* && \
    cd /opt && \
    apk del boost-dev && \
    apk del g++ cmake libc-dev expat-dev zlib-dev bzip2-dev lua5.1-dev git make gcc && \
    apk add boost-filesystem boost-program_options boost-regex boost-iostreams boost-thread libgomp lua5.1 expat && \
    rm -rf /opt/osrm-backend /opt/stxxl /usr/local/bin/stxxl_tool /usr/local/lib/libosrm*

EXPOSE 5000
