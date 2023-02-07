#!/bin/bash

set -eux

curdir=$(cd `dirname $0`;pwd)
cd $curdir

target=$1
ver=$2



target_image=wxc252/base4tcpp:$ver-$target


if [ "$target" = "with-maps" ];then
    tar -xvf ctm-maps.tgz
fi


sudo docker build . --target=$target -t $target_image
sudo docker push $target_image

rm -rf data

