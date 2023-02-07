ARG BASE4TCPP_VER=1.0.0-20.04
## common part
FROM wxc252/base4tcpp:$BASE4TCPP_VER-without-maps as common-without-maps

#ARG LIBBOOST_VER=1.74.0
ARG LIBBOOST_VER=1.71.0

# update and common dependencies
RUN set -eux \
    && bash /wxc/apt/sm \
    && apt upgrade \
    && apt-get install -y --no-install-recommends \
            iputils-ping telnet \
            libmysqlclient21 libreadline8 \
            libboost-system$LIBBOOST_VER libboost-filesystem$LIBBOOST_VER libboost-thread$LIBBOOST_VER \
            libboost-atomic$LIBBOOST_VER libboost-program-options$LIBBOOST_VER libboost-iostreams$LIBBOOST_VER \
    && bash /wxc/apt/usm -r

FROM wxc252/base4tcpp:$BASE4TCPP_VER-with-maps as common-with-maps

#ARG LIBBOOST_VER=1.74.0
ARG LIBBOOST_VER=1.71.0

# update and common dependencies
RUN set -eux \
    && bash /wxc/apt/sm \
    && apt upgrade \
    && apt-get install -y --no-install-recommends \
            iputils-ping telnet \
            libmysqlclient21 libreadline8 mysql-client \
            libboost-system$LIBBOOST_VER libboost-filesystem$LIBBOOST_VER libboost-thread$LIBBOOST_VER \
            libboost-atomic$LIBBOOST_VER libboost-program-options$LIBBOOST_VER libboost-iostreams$LIBBOOST_VER \
    && bash /wxc/apt/usm -r

## builder
FROM common-without-maps as builder
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
# install build tools
RUN set -eux \
    && bash /wxc/apt/sm \
    && apt-get install -y --no-install-recommends iputils-ping telnet net-tools curl wget tcpdump \
    && DEBIAN_FRONTEND=noninteractive  apt install -y --no-install-recommends  git clang cmake make gcc g++ libmysqlclient-dev libssl-dev \
         libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mysql-client p7zip \
    && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100 \
    && bash /wxc/apt/usm -r

WORKDIR /home/$USER_NAME

# change user
USER $USER_NAME

# clone source project
ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://github.com/The-Cataclysm-Preservation-Project/TrinityCore.git trinity --depth=1


WORKDIR /home/$USER_NAME/trinity
RUN mkdir build && cd build \
  && cmake ../ -DCMAKE_INSTALL_PREFIX=~/server \
       -DTOOLS=1 -DWITH_WARNINGS=0
RUN cd build && make -j 6 && make install


## builder
FROM common-without-maps as builder_bak
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
# install build tools
RUN set -eux \
    && bash /wxc/apt/sm \
    && apt-get install -y --no-install-recommends iputils-ping telnet net-tools curl wget tcpdump \
    && apt install -y --no-install-recommends  git clang cmake make gcc g++ libmysqlclient-dev libssl-dev \
         libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mysql-client p7zip \
    && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100 \
    && bash /wxc/apt/usm -r

WORKDIR /home/$USER_NAME
# download ssl
ARG SSL_VER=1.0.2u
RUN wget --no-check-certificate https://www.openssl.org/source/openssl-$SSL_VER.tar.gz \
    && tar -xvf openssl-$SSL_VER.tar.gz \
    && rm -rf openssl-$SSL_VER.tar.gz \
    && chown -R $USER_ID:$GROUP_ID openssl-$SSL_VER

# change user
USER $USER_NAME

# clone source project
ENV GIT_SSL_NO_VERIFY=1
RUN git clone https://github.com/The-Cataclysm-Preservation-Project/TrinityCore.git trinity --depth=1

# compile openssl
WORKDIR /home/$USER_NAME/openssl-$SSL_VER
ENV CFLAGS=-fPIC
RUN ./config  shared --openssldir=/home/$USER_NAME/openssl
RUN make -j $(nproc)
RUN make install

# compile
ENV OPENSSL_ROOT_DIR=/home/$USER_NAME/openssl
ENV OPENSSL_LIBRARIES=/home/$USER_NAME/openssl/lib
ENV OPENSSL_INCLUDE_DIR=/home/$USER_NAME/openssl/include
ENV OPENSSL_CRYPTO_LIBRARIES=/home/$USER_NAME/openssl/lib/libcrypto.a
ENV OPENSSL_SSL_LIBRARIES=/home/$USER_NAME/openssl/lib/libssl.a
WORKDIR /home/$USER_NAME/trinity

RUN mkdir build && cd build \
  && cmake ../ -DCMAKE_INSTALL_PREFIX=~/server \
       -DTOOLS=1 -DWITH_WARNINGS=0
RUN cd build && make -j 6 && make install


##
FROM common-with-maps as bnetserver-with-maps
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
#COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/openssl /home/$USER_NAME/openssl

FROM common-with-maps as worldserver-with-maps
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
#COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/openssl /home/$USER_NAME/openssl

FROM common-with-maps as all-with-maps
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/server /home/$USER_NAME/server
#COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/openssl /home/$USER_NAME/openssl
COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/trinity/sql /home/$USER_NAME/trinity/sql

##
FROM common-without-maps as bnetserver-without-maps
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
#COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/openssl /home/$USER_NAME/openssl

FROM common-without-maps as worldserver-without-maps
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
#COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/openssl /home/$USER_NAME/openssl

FROM common-without-maps as all-without-maps
ARG USER_NAME=trinity
ARG USER_ID=2000
ARG GROUP_ID=2000
COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/server /home/$USER_NAME/server
#COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/openssl /home/$USER_NAME/openssl
COPY --from=builder --chown=$USER_ID:$GROUP_ID /home/$USER_NAME/trinity/sql /home/$USER_NAME/trinity/sql


