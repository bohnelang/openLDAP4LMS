#!/bin/bash

cd BerkeleyDB/db-4.4.20
make distclean 2> /dev/null > /dev/null
make clean 2> /dev/null > /dev/null
cd ..
rm -rf db-4.4.20
cd ..


cd openssl/openssl-0.9.8a
make distclean 2> /dev/null > /dev/null
make clean 2> /dev/null > /dev/null
cd ..
rm -rf openssl-0.9.8a
cd ..



cd openldap/openldap-2.3.32
make distclean 2> /dev/null > /dev/null
make clean 2> /dev/null > /dev/null
cd ..
rm -rf openldap-2.3.32
cd ..


kill `ps -eaf | grep slapd | awk {'print $2'}` 2> /dev/null
rm -rf /tmp/openldap4lms

find . -type f -name "credentialsx.php" -exec rm {} \; -print
