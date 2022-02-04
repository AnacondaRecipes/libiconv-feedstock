#!/bin/sh

cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* ./build-aux/
cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* ./libcharset/build-aux/

./configure --prefix=${PREFIX}  \
            --host=${HOST}      \
            --build=${BUILD}    \
            --enable-static     \
            --disable-rpath     \
            --enable-relocatable

make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install

# TODO :: Only provide a static iconv executable for GNU/Linux.
# TODO :: glibc has iconv built-in. I am only providing it here
# TODO :: for legacy packages (and through gritted teeth).
if [[ ${HOST} =~ .*linux.* ]]; then
  chmod 755 ${PREFIX}/lib/libiconv.so.*
  chmod 755 ${PREFIX}/lib/libcharset.so.*
  chmod 755 ${PREFIX}/lib/preloadable_libiconv.so
fi

# remove libtool files
find $PREFIX -name '*.la' -delete
