apt-get install libssl-dev libmm-dev libkrb5-dev pkg-config libwww-perl libhtml-parser-perl libextutils-xsbuilder-perl libextutils-parsexs-perl chkconfig libgdbm-dev libperl-dev flex

ln -s /etc/init.d /etc/rc.d/init.d

cp /builddir/build/functions /etc/init.d/

# Add the "apache" user
/usr/sbin/useradd -c "Apache" -u 48 -s /sbin/nologin -r -d "/var/www" apache 2> /dev/null || :

mkdir /var/lock/subsys

