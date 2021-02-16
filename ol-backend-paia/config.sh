#!/bin/bash



echo "########################################################"
echo 
echo "Config PAIA  part:"
echo
echo 

CREDF=credentialsx.php

if ! test -e $CREDF 
then 
	read -p "Please enter the PAIA URL (e.g. http://testpaia.ggg.de:7381/DE-Wil):" host 
	echo "ok - you entered: $host"
	echo


	read -p "Please enter the PAIA username with client credentials rights (not normal): " login
	echo "ok - you entered: $login"
	echo

	read -s -p "Please enter the PAIA password for username with client credentials:" passwd
	echo "ok - you entered: $passwd"
	echo

	echo


#-------------------------------------------------------------------------------------



cat > $CREDF <<_EOF_
<?php
\$PAIA_server= "$host";
\$PAIA_user="$login";
\$PAIA_password="$passwd";
?>
_EOF_

chmod 550 $CREDF 


echo 
echo Testing PAIA-API Login...
echo
curl --header "Content-Type: application/x-www-form-urlencoded"   --request POST   --data "grant_type=password&username=$login&password=$passwd"   $host/auth/login
echo
echo



sleep 5

else 
	echo "Warning: $CREDF already exists. Will do take this..."
fi

#-------------------

