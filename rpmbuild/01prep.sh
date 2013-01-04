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
LANG=C
export LANG
unset DISPLAY
 
cd '/builddir/build/BUILD'
rm -rf 'apache-1.3.42'
/bin/mkdir -p apache-1.3.42
cd 'apache-1.3.42'
/bin/bzip2 -dc '/builddir/build/SOURCES/apache_1.3.42.tar.bz2' | /bin/tar -xf - 
STATUS=$?
if [ $STATUS -ne 0 ]; then
  exit $STATUS
fi
/bin/chmod -Rf a+rX,u+w,g-w,o-w .
cd '/builddir/build/BUILD'
/bin/mkdir -p apache-1.3.42
cd 'apache-1.3.42'
/bin/gzip -dc '/builddir/build/SOURCES/mod_ssl-2.8.31-1.3.42.tar.gz' | /bin/tar -xf - 
STATUS=$?
if [ $STATUS -ne 0 ]; then
  exit $STATUS
fi
/bin/chmod -Rf a+rX,u+w,g-w,o-w .
cd '/builddir/build/BUILD'
/bin/mkdir -p apache-1.3.42
cd 'apache-1.3.42'
/bin/gzip -dc '/builddir/build/SOURCES/mod_perl-1.31.tar.gz' | /bin/tar -xf - 
STATUS=$?
if [ $STATUS -ne 0 ]; then
  exit $STATUS
fi
/bin/chmod -Rf a+rX,u+w,g-w,o-w .
cd '/builddir/build/BUILD'
/bin/mkdir -p apache-1.3.42
cd 'apache-1.3.42'
/bin/gzip -dc '/builddir/build/SOURCES/libapreq-1.34.tar.gz' | /bin/tar -xf - 
STATUS=$?
if [ $STATUS -ne 0 ]; then
  exit $STATUS
fi
/bin/chmod -Rf a+rX,u+w,g-w,o-w .

pushd apache_1.3.42
echo "Patch #0 (sslcfg.patch):"
/bin/cat /builddir/build/SOURCES/sslcfg.patch | /usr/bin/patch -s -p0 -b --suffix .sslcfg --fuzz=0

echo "Patch #1 (apache_1.3.39-config.patch):"
/bin/cat /builddir/build/SOURCES/apache_1.3.39-config.patch | /usr/bin/patch -s -p1 -b --suffix .config --fuzz=0

echo "Patch #3 (apache_1.3.39-Makefile.patch):"
/bin/cat /builddir/build/SOURCES/apache_1.3.39-Makefile.patch | /usr/bin/patch -s -p0 -b --suffix .make --fuzz=0

echo "Patch #5 (apache_1.3.20-apachectl-init.patch):"
/bin/cat /builddir/build/SOURCES/apache_1.3.20-apachectl-init.patch | /usr/bin/patch -s -p1 -b --suffix .apachectl-init --fuzz=0

echo "Patch #18 (apache_1.3.42-64bits.patch):"
/bin/cat /builddir/build/SOURCES/apache_1.3.42-64bits.patch | /usr/bin/patch -s -p1 -b --suffix .apache-x86_64 --fuzz=0


echo "Patch #12 (apache_1.3.42-db.patch):"
/bin/cat /builddir/build/SOURCES/apache_1.3.42-db.patch | /usr/bin/patch -s -p1 -b --suffix .dbmdb --fuzz=0

echo "Patch #13 (apache-1.3.39-gcc44.patch):"
/bin/cat /builddir/build/SOURCES/apache-1.3.39-gcc44.patch | /usr/bin/patch -s -p1 -b --suffix .compile --fuzz=0

echo "Patch #15 (apache_1.3.39-ap_getline.patch):"
/bin/cat /builddir/build/SOURCES/apache_1.3.39-ap_getline.patch | /usr/bin/patch -s -p0 -b --suffix .ap_getline --fuzz=0



patch -p0 < ../libapreq-1.34/patches/apache-1.3+apreq.patch
cp ../libapreq-1.34/c/*.[ch] src/lib/apreq/
popd

pushd mod_ssl-2.8.31-1.3.42
echo "Patch #11 (mod_ssl-2.8.4-openssl.patch):"
/bin/cat /builddir/build/SOURCES/mod_ssl-2.8.4-openssl.patch | /usr/bin/patch -s -p1 -b --suffix .openssl --fuzz=0

echo "Patch #14 (mod_ssl-2.8.31-STACK.patch):"
/bin/cat /builddir/build/SOURCES/mod_ssl-2.8.31-STACK.patch | /usr/bin/patch -s -p0 -b --suffix .stack --fuzz=0

echo "Patch #16 (mod_ssl-openssl-x86_64.patch):"
/bin/cat /builddir/build/SOURCES/mod_ssl-openssl-x86_64.patch | /usr/bin/patch -s -p1 -b --suffix .openssl2 --fuzz=0

popd

pushd mod_perl-1.31
echo "Patch #17 (mp1+perl5.14.diff) IGNORED for perl 5.10:"
#/bin/cat /builddir/build/SOURCES/mp1+perl5.14.diff | /usr/bin/patch -s -p1 -b --suffix .mp1+perl5.14.diff --fuzz=0

popd

# Substitute values to match the configuration.  The first two are
# for the default httpd.conf file, the rest is for the mod_ssl
# additions.
pushd apache_1.3.42
sed -e 's,@@ServerRoot@@,/etc/httpd13,g' \
    -e 's,@@ContentRoot@@,/var/www,g' \
    -e 's,^DocumentRoot "@@ContentRoot@@",#DocumentRoot "/etc/httpd13/htdocs",g' \
    -e 's,^<Directory "@@ContentRoot@@/cgi-bin">,<Directory "/var/www/cgi-bin">,g' \
    -e 's,^ServerName new.host.name,#ServerName new.host.name,g' \
    -e 's,^ServerAdmin you@your.address,#ServerAdmin you@your.address,g' \
    -e 's,^SSLCipherSuite,#SSLCipherSuite,g' \
    -e 's,^SSLLogLevel info,SSLLogLevel error,g' \
    -e 's,^SSLSessionCache         dbm:logs/ssl_scache,SSLSessionCache         shm:logs/ssl_scache(512000),g' \
    conf/httpd.conf-dist > conf/httpd.conf
popd

cp /builddir/build/SOURCES/SSL-Certificate-Creation .

exit 0
