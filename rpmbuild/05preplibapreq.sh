#!/bin/bash

  RPM_SOURCE_DIR="/builddir/build/SOURCES"
  RPM_BUILD_DIR="/builddir/build/BUILD"
  RPM_OPT_FLAGS="-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4  -m64 -mtune=generic"
  RPM_LD_FLAGS="-Wl,-z,relro "
  RPM_ARCH="x86_64"
  RPM_OS="linux"
  export RPM_SOURCE_DIR RPM_BUILD_DIR RPM_OPT_FLAGS RPM_LD_FLAGS RPM_ARCH RPM_OS
  RPM_DOC_DIR="/usr/share/doc"
  export RPM_DOC_DIR
  RPM_PACKAGE_NAME="libapreq"
  RPM_PACKAGE_VERSION="1.34"
  RPM_PACKAGE_RELEASE="1.fc16"
  export RPM_PACKAGE_NAME RPM_PACKAGE_VERSION RPM_PACKAGE_RELEASE
  LANG=C
  export LANG
  unset CDPATH DISPLAY ||:
  RPM_BUILD_ROOT="/builddir/build/BUILDROOT/libapreq-1.34-1.fc16.x86_64"
  export RPM_BUILD_ROOT
  
  PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:/usr/local/share/pkgconfig"
  export PKG_CONFIG_PATH
  
  set -x
  umask 022
  cd "/builddir/build/BUILD"
LANG=C
export LANG
unset DISPLAY
 
cd '/builddir/build/BUILD'
/bin/mkdir -p libapreq-1.34
cd 'libapreq-1.34'
/bin/gzip -dc '/builddir/build/SOURCES/libapreq-1.34.tar.gz' | /bin/tar -xf - 
STATUS=$?
if [ $STATUS -ne 0 ]; then
  exit $STATUS
fi
/bin/chmod -Rf a+rX,u+w,g-w,o-w .

exit 0
