#!/bin/bash



echo "########################################################"
echo 
echo "Config FOLIO  part:"
echo
echo 

CREDF=credentialsx.php

if ! test -e $CREDF 
then 
	read -p "Please enter the FOLIO URL (e.g. https://folio-demo.hbz-nrw.de or https://folio-demo.gbv.de / defaut,demo: https://folio-demo.hbz-nrw.de ):" host 
	if test "`echo $host`" = ""
	then 
		host=https://folio-demo.hbz-nrw.de
	fi
	echo "ok - you entered: $host"
	echo

	read -p "Please enter the FOLIO tenant (defaut,demo: diku ):" tenant 
        if test "`echo $tenant`" = ""
	then 
		tenant=diku 
	fi
        echo "ok - you entered: $tenant"

        echo

	read -p "Please enter the FOLIO login (defaut,demo: diku_admin): " login
	if test "`echo $login`" = "" 
	then
		 login=diku_admin 
	fi
	echo "ok - you entered: $login"
	echo

	read -s -p "Please enter the FOLIO password (defaut,demo: admin):" passwd
	if test "`echo $passwd`" = ""
	then 
		passwd=admin 
	fi
	echo "ok - you entered: $passwd"
	echo

	echo


#-------------------------------------------------------------------------------------



cat > $CREDF <<_EOF_
<?php
\$FOLIO_server= "$host";
\$FOLIO_tenant= "$tenant";
\$FOLIO_user="$login";
\$FOLIO_password="$passwd";
?>
_EOF_

chmod 550 $CREDF 


echo 
echo Testing FOLIO Login...
echo
# Thanks to Jürgen Kuss 
USERNAME="diku*"
OKAPI=$host/okapi
TOKEN=$( curl -s -S -D - -H "X-Okapi-Tenant: $tenant" -H "Content-type: application/json" -H "Accept: application/json" -d "{\"tenant\" : \"$tenant\", \"username\" : \"$login\", \"password\" : \"$passwd\"}"  $OKAPI/authn/login | grep -i "^x-okapi-token: " )
curl -s -S -X GET -H "$TOKEN" -H "X-Okapi-Tenant: $tenant" -H "Content-type: application/json; charset=utf-8" -H "Accept: application/json" $OKAPI/bl-users?query=username=$USERNAME


echo
echo



sleep 5

else 
	echo "Warning: $CREDF already exists. Will do take this..."
fi

#-------------------

