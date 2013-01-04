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
  RPM_PACKAGE_NAME="apache"
  RPM_PACKAGE_VERSION="1.3.42"
  RPM_PACKAGE_RELEASE="4.fc16"
  export RPM_PACKAGE_NAME RPM_PACKAGE_VERSION RPM_PACKAGE_RELEASE
  LANG=C
  export LANG
  unset CDPATH DISPLAY ||:
  RPM_BUILD_ROOT="/builddir/build/BUILDROOT/apache-1.3.42-4.fc16.i386"
  export RPM_BUILD_ROOT
  
  PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig"
  export PKG_CONFIG_PATH
  
  set -x
  umask 022
  cd "/builddir/build/BUILD"
    [ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "${RPM_BUILD_ROOT}"
    mkdir -p `dirname "$RPM_BUILD_ROOT"`
    mkdir "$RPM_BUILD_ROOT"

cd 'apache-1.3.42'
LANG=C
export LANG
unset DISPLAY

###############################################################################
### install basic apache stuff
pushd apache_1.3.42
  make install root="$RPM_BUILD_ROOT"
popd

### rename 
mv $RPM_BUILD_ROOT/usr/local/sbin/httpd $RPM_BUILD_ROOT/usr/local/sbin/httpd13

### install SYSV init stuff
mkdir -p $RPM_BUILD_ROOT/etc/rc.d/init.d
install -m755 /builddir/build/SOURCES/httpd.init $RPM_BUILD_ROOT/etc/rc.d/init.d/httpd13

### install log rotation stuff
mkdir -p $RPM_BUILD_ROOT/etc/logrotate.d
install -m644 /builddir/build/SOURCES/apache.logrotate $RPM_BUILD_ROOT/etc/logrotate.d/apache

### default rootdir links
mkdir -p $RPM_BUILD_ROOT/var/log/httpd13
pushd $RPM_BUILD_ROOT/etc/httpd13
	ln -s /var/log/httpd13 logs
	ln -s /usr/local/lib/apache modules
	ln -s /var/run run
popd

### replace Apache's default config file with our patched version
install -m644 apache_1.3.42/conf/httpd.conf \
	$RPM_BUILD_ROOT/etc/httpd13/conf/httpd.conf

# fix up apxs so that it doesn't think it's in the build root
perl -pi -e "s^$RPM_BUILD_ROOT^^g" $RPM_BUILD_ROOT/usr/local/sbin/apxs

# fixup the documentation file naming
find $RPM_BUILD_ROOT/var/www -name "*.html.html" | xargs rename .html.html .html

###############################################################################
### install mod_perl files
pushd mod_perl-1.31
  export PERL_INSTALL_ROOT=$RPM_BUILD_ROOT 
  make pure_install PREFIX=/usr INSTALLDIRS=vendor

  # convert man pages to UTF-8
  recode() {
    iconv -f "$2" -t utf-8 < "$1" > "${1}_"
    /bin/mv -f "${1}_" "$1"
  }
  pushd $RPM_BUILD_ROOT/usr/share/man/man3/
	for i in * ; do
		recode "${i}" iso-8859-1
	done
  popd

  # fix files mod
  find $RPM_BUILD_ROOT/usr/lib/perl5/vendor_perl -iname '*.pm' -exec chmod 0644 {} \;

  # bake web docs...
  mkdir -p $RPM_BUILD_ROOT/var/www/html/manual/mod/mod_perl
  install -c -m 644 htdocs/manual/mod/mod_perl.html \
        $RPM_BUILD_ROOT/var/www/html/manual/mod/mod_perl/
  make -C faq
  rm -f faq/pod2htm*
  install -m644 faq/*.html \
    $RPM_BUILD_ROOT/var/www/html/manual/mod/mod_perl/

popd

# remove special perl files this is specific for rpms , already have in own .packlist
find $RPM_BUILD_ROOT/usr/lib/perl5/vendor_perl/.. -name perllocal.pod -o -name .packlist \
    -o -name '*.bs' | xargs -r -i rm -f {}

### ssl leftovers
# point to the right makefile.
ln -sf ../../../etc/pki/tls/certs/Makefile $RPM_BUILD_ROOT/etc/httpd13/conf
# create a prototype session cache
touch $RPM_BUILD_ROOT/var/cache/ssl_gcache_data.{dir,pag,sem}

# drop shellbang from .exp files
for exp in $RPM_BUILD_ROOT/usr/lib/perl5/vendor_perl/auto/Apache/mod_perl.exp $RPM_BUILD_ROOT/usr/local/lib/apache/httpd.exp
do
	sed -i '/^#!/ d' $exp
done

