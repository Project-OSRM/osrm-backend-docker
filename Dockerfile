# OSRM processing tools, server and profile

FROM alpine:3.4
ARG OSRM_VERSION
RUN mkdir /opt
WORKDIR /opt
RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add git cmake wget make libc-dev gcc g++ bzip2-dev boost-dev zlib-dev expat-dev lua5.1-dev libtbb@testing libtbb-dev@testing && \
    \
    echo "Building Luabind" && \
    cd /opt && \
    git clone --depth 1 --branch master https://github.com/mapbox/luabind.git && \
    cd luabind && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    \
    echo "Building libstxxl" && \
    cd /opt && \
    git clone --depth 1 --branch 1.4.1 https://github.com/stxxl/stxxl.git && \
    cd stxxl && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    \
    echo "Building OSRM ${OSRM_VERSION}" &&\
    cd /opt && \
    git clone https://github.com/Project-OSRM/osrm-backend.git && \
    cd osrm-backend && \
    git checkout ${OSRM_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -DLUABIND_INCLUDE_DIR=/usr/local/include .. && \
    make install && \
    cd ../profiles && \
    cp -r * /opt && \
    \
    echo "Cleaning up" && \
    strip /usr/local/bin/* && \
    rm /usr/local/lib/libstxxl* /usr/local/lib/libluabind* && \
    cd /opt && \
    apk del boost-dev && \
    apk del g++ cmake libc-dev expat-dev zlib-dev bzip2-dev lua5.1-dev git make gcc && \
    apk add boost-filesystem boost-program_options boost-regex boost-iostreams boost-thread libgomp lua5.1 expat && \
    rm -rf /opt/osrm-backend /opt/stxxl /opt/luabind /usr/local/bin/stxxl_tool
