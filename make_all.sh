#!/bin/bash

if test "`lsb_release -d | grep -i ubuntu `" != ""
then

	for I in gcc gmake make libtool libsasl2-dev recode librecode-dev
	do
		apt-get --assume-yes install $I 2> /dev/null > /dev/null
	done
else
	echo "This demo is prepared for Ubuntu. Please install the packages gcc gmake make libtool libsasl2-dev  recode librecode-dev manually"
fi


if test "`which php`" = ""
then
	echo "This demo  uses a vary simple demo backend written in php"
	echo "Either you install php or you rewrite the backend in your favored programming language :)"
	exit 0
fi 


echo
echo
read -p "Path where the openldap should be installed (Test default: /tmp/openldap4lms/):" inst
echo

if test $inst=''
then 
	inst=/tmp/openldap4lms
fi 

if ! test -e $inst
then
	mkdir -p $inst
fi

echo "You entered $inst"
sleep 5

export inst

h=`pwd` 

echo "---------------------------------"
echo
echo "Compiling BerkeleyDB "
#https://github.com/berkeleydb/libdb.git
#git checkout berkeleyDB_4_4_20
cd BerkeleyDB
./inst.sh
cd $h

echo "---------------------------------"
echo
echo "Compiling openssl "
#git clone https://github.com/openssl/openssl.git
#git checkout OpenSSL_0_9_8a-stable
cd openssl 
./inst.sh
cd $h


echo "---------------------------------"
echo
echo "Compiling openldap" 
#git clone https://github.com/openldap/openldap.git
#git checkout openldap-2_3_32-stable
cd openldap 
./inst.sh
cd $h


echo "---------------------------------"
echo
echo "Installing library backend "
echo

read -p "Please enter backend (available=[demo,alma,folio,sisis,paia,koha,moodle] / default=demo):" be
        if test "`echo $be`" = ""
        then
                be='demo'
        fi

cd ol-backend-$be
./inst.sh
cd $h



echo "---------------------------------"
echo
echo "Init and start ldap"
cd ol-init
./inst.sh
cd $h


#echo
#echo
#echo "Cleaning up..."
#echo
#cd BerkeleyDB
#make clean 2> /dev/null > /dev/null
#cd ../openldap/openldap-2.3.32
#make clean 2> /dev/null > /dev/null
#cd $h 



exit

