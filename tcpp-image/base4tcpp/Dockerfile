# base4tcpp-without-maps
ARG UBUNTU_VER=20.04
FROM wxc252/ubuntu:$UBUNTU_VER-tools as without-maps

ARG USER_NAME=trinity
ARG GROUP_NAME=trinity
ARG GROUP_ID=2000
ARG USER_ID=2000

RUN groupadd -g $GROUP_ID $GROUP_NAME \
  &&  useradd -g $GROUP_ID -u $USER_ID -m -s /bin/bash $USER_NAME

# base4tcpp-with-maps
FROM without-maps as with-maps
ARG GROUP_ID=2000
ARG USER_ID=2000
COPY --chown=$USER_ID:$GROUP_ID data /home/$USER_NAME/server/data

