#!/bin/bash

MIRROR=registry.home

set -ex

function mirror {
    CHART=$1
    CHARTDIR=$(mktemp -d)
    helm fetch suse/$1 --untar --untardir=${CHARTDIR}
    IMAGES=$(cat ${CHARTDIR}/**/imagelist.txt)
    for IMAGE in ${IMAGES}; do
        echo $IMAGE
        docker pull registry.suse.com/cap/$IMAGE
        docker tag registry.suse.com/cap/$IMAGE $MIRROR/cap/$IMAGE
        docker push $MIRROR/cap/$IMAGE
    done
    docker save -o ${CHART}-images.tar.gz \
           $(perl -E "say qq(registry.suse.com/cap/\$_) for @ARGV" ${IMAGES})
    rm -r ${CHARTDIR}
}

mirror cf
mirror uaa
mirror console
mirror metrics
mirror cf-usb-sidecar-mysql
mirror cf-usb-sidecar-postgres
