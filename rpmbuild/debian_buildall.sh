rm -rf BUILD/apache-1.3.42/
sh 01prep.sh 
sh 02build.sh 
rm -rf BUILDROOT/apache-1.3.42-4.fc16.x86_64/
sh 03install.sh

rm -rf BUILD/libapreq-1.34/
sh 05preplibapreq.sh
sh 06buildlibapreq.sh
rm -rf BUILDROOT/libapreq-1.34-1.fc16.x86_64
sh 07installlibapreq.sh

echo Done

cd BUILDROOT/apache-1.3.42-4.fc16.x86_64/
tar czf ../../apache-1.3.42.tgz *
cd ../libapreq-1.34-1.fc16.x86_64/
tar czf ../../libapreq-1.34.tgz *
cd ../..

echo Packing done.
echo To install, do as root:
echo tar zxvf /builddir/build/apache-1.3.42.tgz -C /
echo tar zxvf /builddir/build/libapreq-1.34.tgz -C /
echo it misses apply the patch httpd13.patch ... 
echo in 04post.sh we have an example of configuration of service httpd13 e gen certificates. 
