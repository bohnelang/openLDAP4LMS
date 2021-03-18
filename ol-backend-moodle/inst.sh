#!/bin/bash

if test "`echo $inst`" = ""
then
        inst=/tmp/openldap4lms
fi


./config.sh

echo 
echo "Installing search module search_library to $inst/modules/"
echo 

if ! test -e  $inst/modules/
then 
	mkdir  $inst/modules/
fi
cp ./credentialsx.php ./search_library  $inst/modules/
