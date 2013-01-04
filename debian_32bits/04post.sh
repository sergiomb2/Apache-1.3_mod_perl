/sbin/chkconfig --add httpd13
/sbin/ldconfig

# safely build a test certificate
umask 077
if [ ! -f /etc/httpd13/conf/ssl.key/server.key ] ; then
openssl genrsa -rand /proc/apm:/proc/cpuinfo:/proc/dma:/proc/filesystems:/proc/interrupts:/proc/ioports:/proc/pci:/proc/rtc:/proc/uptime 1024 > /etc/httpd13/conf/ssl.key/server.key 2> /dev/null
fi

if [ ! -f /etc/httpd13/conf/ssl.crt/server.crt ] ; then
cat << EOF | openssl req -new -key /etc/httpd13/conf/ssl.key/server.key -x509 -days 365 -out /etc/httpd13/conf/ssl.crt/server.crt 2>/dev/null
--
SomeState
SomeCity
SomeOrganization
SomeOrganizationalUnit
localhost.localdomain
root@localhost.localdomain
EOF
fi

# safely add .htm to mime types if it is not already there
[ -f /etc/mime.types ] || exit 0
TEMPTYPES=`/bin/mktemp /tmp/mimetypes.XXXXXX`
[ -z "$TEMPTYPES" ] && {
  echo "could not make temporary file, htm not added to /etc/mime.types" >&2
  exit 1
}
( grep -v "^text/html"  /etc/mime.types
  types=$(grep "^text/html" /etc/mime.types | cut -f2-)
  echo -en "text/html\t\t\t"
  for val in $types ; do
      if [ "$val" = "htm" ] ; then
          continue
      fi
      echo -n "$val "
  done
  echo "htm"
) > $TEMPTYPES
cat $TEMPTYPES > /etc/mime.types && /bin/rm -f $TEMPTYPES

