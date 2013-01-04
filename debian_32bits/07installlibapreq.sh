#!/bin/bash

  RPM_SOURCE_DIR="/builddir/build/SOURCES"
  RPM_BUILD_DIR="/builddir/build/BUILD"
  RPM_OPT_FLAGS="-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4  -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables"
  RPM_LD_FLAGS="-Wl,-z,relro "
  RPM_ARCH="i386"
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
  RPM_BUILD_ROOT="/builddir/build/BUILDROOT/libapreq-1.34-1.fc16.i386"
  export RPM_BUILD_ROOT
  
  PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig"
  export PKG_CONFIG_PATH
  
  set -x
  umask 022
  cd "/builddir/build/BUILD"
    [ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "${RPM_BUILD_ROOT}"
    mkdir -p `dirname "$RPM_BUILD_ROOT"`
    mkdir "$RPM_BUILD_ROOT"

cd 'libapreq-1.34'
LANG=C
export LANG
unset DISPLAY

pushd libapreq-1.34
  export PERL_INSTALL_ROOT=$RPM_BUILD_ROOT 
  make install
  mkdir libapreq-doc
  cp -r {Changes,CREDITS,INSTALL*,LICENSE,README,ToDo,eg/} libapreq-doc/
  find libapreq-doc -type f -exec chmod 644 {} \;
popd

    export PERL5LIB=$(echo $RPM_BUILD_ROOT/usr/lib/perl5/vendor_perl)
    # remove special perl files
    find $PERL5LIB/.. -name perllocal.pod -o -name .packlist \
        -o -name '*.bs' | xargs -r -i rm -f {}

    #permition to user write and strip
    find $PERL5LIB/auto/libapreq -type f -exec chmod 644 {} \;
###############################################################################

