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
  RPM_PACKAGE_NAME="apache"
  RPM_PACKAGE_VERSION="1.3.42"
  RPM_PACKAGE_RELEASE="4.fc16"
  export RPM_PACKAGE_NAME RPM_PACKAGE_VERSION RPM_PACKAGE_RELEASE
  LANG=C
  export LANG
  unset CDPATH DISPLAY ||:
  RPM_BUILD_ROOT="/builddir/build/BUILDROOT/apache-1.3.42-4.fc16.x86_64"
  export RPM_BUILD_ROOT
  
  PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig:/usr/local/share/pkgconfig"
  export PKG_CONFIG_PATH
  
  set -x
  umask 022
  cd "/builddir/build/BUILD"
cd 'apache-1.3.42'
LANG=C
export LANG
unset DISPLAY

export CFLAGS="$RPM_OPT_FLAGS -fPIC $(pkg-config --cflags openssl)"
export LIBS="-lpthread"
export EAPI_MM=SYSTEM

###############################################
echo mod_perl ...
pushd mod_perl-1.31
  perl Makefile.PL CCFLAGS="$RPM_OPT_FLAGS -fPIC" \
    APACHE_SRC=../apache_1.3.42/src \
    DO_HTTPD=1 USE_APACI=1 PREP_HTTPD=1 EVERYTHING=1
  make -j4
  ## put mod_perl docs in a safe place ;-]~
  mkdir mod_perl-doc
  cp -a eg/ faq/ mod_perl-doc/
  cp {CREDITS,LICENSE,README,SUPPORT,STATUS,Changes,INSTALL*} mod_perl-doc/
  cp *.{pod,html,gif} mod_perl-doc/
  find mod_perl-doc -type f -exec chmod 644 {} \;
popd

###############################################
echo mod_ssl ...
export SSL_COMPAT=yes
export SSL_EXPERIMENTAL=yes
pushd mod_ssl-2.8.31-1.3.42
  ./configure --with-apache=../apache_1.3.42 \
    --with-mm=SYSTEM --force
popd

###############################################
echo apache ...
pushd apache_1.3.42
  ./configure \
 	--prefix=/usr/local \
 	--exec-prefix=/usr/local \
 	--bindir=/usr/local/bin \
 	--sbindir=/usr/local/sbin \
 	--mandir=/usr/local/man \
	--sysconfdir=/etc/httpd13/conf \
	--libexecdir=/usr/local/lib64/apache \
	--datadir=/var/www \
	--iconsdir=/var/www/icons \
	--htdocsdir=/var/www/html \
	--manualdir=/var/www/html/manual \
	--cgidir=/var/www/cgi-bin \
 	--localstatedir=/var \
	--runtimedir=/etc/httpd13/run \
	--logfiledir=logs \
	--proxycachedir=/var/cache/httpd13 \
	--with-perl=/usr/bin/perl \
	--enable-rule=EAPI \
	--enable-rule=SSL_COMPAT \
	--enable-rule=SSL_EXPERIMENTAL \
	--disable-rule=SSL_VENDOR \
	--disable-rule=WANTHSREGEX \
	--disable-rule=EXPAT \
	 \
	 \
	--activate-module=src/modules/perl/libperl.a \
	--enable-module=auth_dbm \
	--enable-module=ssl \
	--enable-module=all \
	--enable-shared=max \
	--disable-shared=perl \
	--disable-shared=ssl \
	--disable-module=example \
	--disable-module=auth_db \
	--without-execstrip \
	 \
	 \
	

  make -j4

popd


exit 0
