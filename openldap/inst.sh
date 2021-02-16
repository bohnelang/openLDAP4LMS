#!/bin/bash

d=`pwd`

if test "`echo $inst`" = ""
then
        inst=/tmp/openldap4lms
fi

echo > /tmp/comp_ol.out
echo > /tmp/comp_ol.err

if ! test -e openldap-2.3.32
then
	wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.3.32.tgz
	tar xzf openldap-2.3.32.tgz
	rm -f openldap-2.3.32.tgz
fi 	
  

cd openldap-2.3.32

export CPPFLAGS="-I$inst/include/ -D_GNU_SOURCE"
export LDFLAGS="-L$inst/lib -Wl,--rpath -Wl,$inst/lib"

make clean 		2> /dev/null > /dev/null	
make distclean 		2> /dev/null > /dev/null	

./configure			\
	--prefix=$inst		\
	--without-threads 	\
	--with-tls		\
    	--enable-backends	\
	--enable-overlays	\
	--enable-perl=no	\
	--enable-sql=no		>> /tmp/comp_ol.out 2>> /tmp/comp_ol.err 


make depend >> /tmp/comp_ol.out 2>> /tmp/comp_ol.err

make -j4 >> /tmp/comp_ol.out 2>> /tmp/comp_ol.err

make install >> /tmp/comp_ol.out 2>> /tmp/comp_ol.err

make clean            	2> /dev/null > /dev/null 

if ! test -e $inst/bin/ldapsearch
then
        tail -n 10 /tmp/comp_ol.err
        echo "Check  /tmp/comp_ol.err  /tmp/comp_ol.out ..."
        exit 0
fi




TSLS=$inst/etc/openldap/server.pem

#Country Name (2 letter code) [AU]:DE
#State or Province Name (full name) [Some-State]:
#Locality Name (eg, city) []:
#Organization Name (eg, company) [Internet Widgits Pty Ltd]:
#Organizational Unit Name (eg, section) []:
#Common Name (e.g. server FQDN or YOUR name) []:ldaps://localhost/
#Email Address []:


$inst/bin/openssl req -newkey rsa:1024 -x509 -nodes -out $TSLS -keyout $TSLS  -days 999 2> /dev/null > /dev/null  <<_EOF_
AU
District of Books
Booktown
Headquarter
Library 
localhost

_EOF_

