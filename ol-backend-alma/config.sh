#!/bin/bash



echo "########################################################"
echo 
echo "Config Alma  part:"
echo
echo 

CREDF=credentialsx.php

if ! test -e $CREDF 
then 
	# https://developers.exlibrisgroup.com/console/?url=/wp-content/uploads/alma/openapi/users.json#/Users/get%2Falmaws%2Fv1%2Fusers
	#$ALMA_SERVER = "api-eu.hosted.exlibrisgroup.com";               // European
	#$ALMA_APIKEY = "l7xx2af7939c63424511946e0fcdc35fe22a";          // official demo key - readonly

	echo
	echo "ALMA Hosts:"
	echo "Europe         api-eu.hosted.exlibrisgroup.com"
	echo "North America  api-na.hosted.exlibrisgroup.com"
	echo "Asia Pacific   api-ap.hosted.exlibrisgroup.com"
	echo "Canada         api-ca.hosted.exlibrisgroup.com"
	echo "China          api-cn.hosted.exlibrisgroup.com"
	read -p "Please enter the ALMA host / defaut,demo: api-eu.hosted.exlibrisgroup.com ):" host 
	if test "`echo $host`" = ""
	then 
		host=api-eu.hosted.exlibrisgroup.com
	fi
	echo "ok - you entered: $host"
	echo

	read -p "Please enter the API-KEY(defaut,demo: l7xx2af7939c63424511946e0fcdc35fe22a ):" apikey 
        if test "`echo $apikey`" = ""
	then 
		apikey=l7xx2af7939c63424511946e0fcdc35fe22a 
	fi
        echo "ok - you entered: $apikey"

        echo



#-------------------------------------------------------------------------------------



cat > $CREDF <<_EOF_
<?php
\$ALMA_SERVER= "$host";
\$ALMA_APIKEY= "$apikey";
?>
_EOF_

chmod 550 $CREDF 


echo 
echo Testing Alma Login for Smith...
echo
echo  Checking "https://$host/almaws/v1/users?limit=10&offset=0&q=last_name~Smith&order_by=last_name&apikey=$apikey" 
curl -X GET "https://$host/almaws/v1/users?limit=10&offset=0&q=last_name~Smith&order_by=last_name&apikey=$apikey" -H  "accept: application/json"

echo
echo



sleep 5

else 
	echo "Warning: $CREDF already exists. Will do take this..."
fi

#-------------------

