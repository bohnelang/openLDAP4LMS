#!/bin/bash

if test "`echo $inst`" = ""
then 
	inst=/tmp/openldap4lms/	
fi 

echo > /tmp/comp_BDB.out
echo > /tmp/comp_BDB.err

if ! test -e db-4.4.20 
then
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/bdbsq/db-4.4.20.tar.gz
	tar xzf db-4.4.20.tar.gz
	rm -f db-4.4.20.tar.gz
fi 


cd db-4.4.20

cd build_unix

../dist/configure		\
	--prefix=$inst		\
	--enable-debug 		\
	--enable-diagnostic >> /tmp/comp_BDB.out 2>> /tmp/comp_BDB.err	


make clean >> /tmp/comp_BDB.out 2>> /tmp/comp_BDB.err 

make  >> /tmp/comp_BDB.out 2>> /tmp/comp_BDB.err

make install >> /tmp/comp_BDB.out 2>> /tmp/comp_BDB.err

make clean >> /tmp/comp_BDB.out 2>> /tmp/comp_BDB.err

#tail /tmp/comp_BDB.out
if ! test -e $inst/bin/db_verify
then
	tail -n 10 /tmp/comp_BDB.err
	echo "Check  /tmp/comp_BDB.err  /tmp/comp_BDB.out ..."
	exit 0
fi
