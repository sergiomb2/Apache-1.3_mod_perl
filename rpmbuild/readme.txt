sh prep.sh 
sh build.sh 
sh install.sh 

+---------------------------------------------------------------------+
| % make certificate TYPE=dummy    (dummy self-signed Snake Oil cert) |
| % make certificate TYPE=test     (test cert signed by Snake Oil CA) |
| % make certificate TYPE=custom   (custom cert signed by own CA)     |
| % make certificate TYPE=existing (existing cert)                    |
|        CRT=/path/to/your.crt [KEY=/path/to/your.key]                |
|                                                                     |
| Use TYPE=dummy    when you're a  vendor package maintainer,         |
| the TYPE=test     when you're an admin but want to do tests only,   |
| the TYPE=custom   when you're an admin willing to run a real server |
| and TYPE=existing when you're an admin who upgrades a server.       |
| (The default is TYPE=test)                                          |
|                                                                     |
| Additionally add ALGO=RSA (default) or ALGO=DSA to select           |
| the signature algorithm used for the generated certificate.         |
|                                                                     |
| Use 'make certificate VIEW=1' to display the generated data.        |
+---------------------------------------------------------------------+

cd BUILD/apache-1.3.42/apache_1.3.42/
make certificate TYPE=test
cp conf/ssl.key/server.key /servers/apache/conf/ssl.key/
cp conf/ssl.crt/server.crt /servers/apache/conf/ssl.crt/
cp conf/ssl.csr/server.csr /servers/apache/conf/ssl.csr/

cd /servers/apache/
mkdir run
mkdir var/cache
cd var/cache/
touch ssl_gcache_data.{dir,pag,sem}



#removepassphrase
Remove the encryption from the RSA private key (while keeping a backup copy of the original file):

$ cp server.key server.key.org
$ openssl rsa -in server.key.org -out server.key

Make sure the server.key file is only readable by root:

$ chmod 400 server.key
