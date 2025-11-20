FROM ubuntu:22.04 AS build

RUN apt update && \
    apt install -yq cmake build-essential ninja-build \
    libcrypto++-dev libfmt-dev liblua5.4-dev libluajit-5.1-dev libmysqlclient-dev \
    libboost-iostreams-dev libboost-locale-dev libboost-system-dev libpugixml-dev

RUN apt install -yq libboost-filesystem-dev

COPY cmake /usr/src/forgottenserver/cmake/
COPY src /usr/src/forgottenserver/src/
COPY CMakeLists.txt /usr/src/forgottenserver/
WORKDIR /usr/src/forgottenserver

RUN mkdir build && cd build && cmake .. && make -j 32

FROM ubuntu:22.04

RUN apt update && \
    apt install -yq cmake build-essential ninja-build \
    libcrypto++-dev libfmt-dev liblua5.4-dev libluajit-5.1-dev libmysqlclient-dev \
    libboost-iostreams-dev libboost-locale-dev libboost-system-dev libpugixml-dev

RUN apt install -yq libboost-filesystem-dev

COPY --from=build /usr/src/forgottenserver/build/tfs /bin/tfs

EXPOSE 7171 7172
WORKDIR /srv
VOLUME /srv
ENTRYPOINT ["/bin/tfs"]
