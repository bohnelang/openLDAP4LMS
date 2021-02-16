#!/bin/bash

if test "`echo $inst`" = ""
then
        inst=/tmp/openldap4lms
fi

echo 
echo "Installing search module search_library to $inst/modules/"
echo 

if ! test -e  $inst/modules/
then 
	mkdir  $inst/modules/
fi
cp ./search_library $inst/modules/
