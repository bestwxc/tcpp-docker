#!/bin/bash

# $1 target
# $2 ver

set -eux

curdir=$(cd `dirname $0`;pwd)
cd $curdir

target=$1
ver=$2



target_image=wxc252/tcpp:$ver-$target

sudo docker build . --target=$target -t $target_image
sudo docker push $target_image


