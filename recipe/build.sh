#!/bin/bash

set -x

if [ "$(uname)" = "Darwin" ]; then
    LIB_FLAG='-dynamiclib'
    EXT='.dylib'
    # Hack, use my own compiler. I could not make the conda fortran work
    # as it expects libgfortran 4 which is incompatible with LAPACK.
    FC=/usr/local/bin/gfortran
    FFLAGS=''
    LDFLAGS=''
else
    LIB_FLAG='-shared'
    EXT='.so'
fi


# Build
${FC} ${FFLAGS} -fPIC -O3 -c interp_2p5min.f
${FC} ${LDFLAGS} ${LIB_FLAG} -o libegm2008${EXT} interp_2p5min.o

if [ "$(uname)" = "Darwin" ]; then
    for dep in libgfortran.3 libquadmath.0 libgcc_s.1; do 
        /usr/bin/install_name_tool -change /usr/local/lib/${dep}.dylib \
            @rpath/${dep}.dylib libegm2008${EXT}
    done
fi

# Install
mkdir -p ${PREFIX}/lib
cp -fv libegm2008.* ${PREFIX}/lib
GEOID_DIR=${PREFIX}/share/geoids
mkdir -p ${GEOID_DIR}
cp -fv *tif *jp2 ${GEOID_DIR}
