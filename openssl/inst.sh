#!/bin/bash

if test "`echo $inst`" = ""
then
        inst=/tmp/openldap4lms
fi

echo > /tmp/comp_ssl.out
echo > /tmp/comp_ssl.err

if ! test -e openssl-0.9.8a
then

	wget https://ftp.openssl.org/source/old/0.9.x/openssl-0.9.8a.tar.gz
	tar xzf openssl-0.9.8a.tar.gz
	rm -f openssl-0.9.8a.tar.gz
fi


d=`pwd`

cd openssl-0.9.8a 

make clean 2> /dev/null > /dev/null

./Configure --prefix=$inst --openssldir=$inst shared  linux-generic64  2>> /tmp/comp_ssl.err >>  /tmp/comp_ssl.out

make  2>> /tmp/comp_ssl.err >>  /tmp/comp_ssl.out  

make install_sw  2>> /tmp/comp_ssl.err >>  /tmp/comp_ssl.out

make clean 2> /dev/null > /dev/null

if ! test -e $inst/bin/openssl
then
        tail -n 10 /tmp/comp_ssl.err
        echo "Check  /tmp/comp_ssl.err  /tmp/comp_ssl.out ..."
        exit 0
fi

