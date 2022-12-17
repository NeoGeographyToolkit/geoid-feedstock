#!/bin/bash

set -x

if [ "$(uname)" = "Darwin" ]; then
    LIB_FLAG='-dynamiclib'
    EXT='.dylib'
else
    LIB_FLAG='-shared'
    EXT='.so'
fi


# Build
${FC} ${FFLAGS} -fPIC -O3 -c interp_2p5min.f
${FC} ${LDFLAGS} ${LIB_FLAG} -o libegm2008${EXT} interp_2p5min.o

# Install
mkdir -p ${PREFIX}/lib
cp -fv libegm2008.* ${PREFIX}/lib
GEOID_DIR=${PREFIX}/share/geoids
mkdir -p ${GEOID_DIR}
cp -fv *tif *jp2 ${GEOID_DIR}
