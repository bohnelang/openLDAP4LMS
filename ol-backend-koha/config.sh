#!/bin/bash


if test "`dpkg -l | grep -i php-mysql`" = ""
then
        apt-get install php-db php-mysql  2> /dev/null > /dev/null
fi


echo "########################################################"
echo 
echo "Config Koha database access part:"
echo
echo 

CREDF=credentialsx.php

if ! test -e $CREDF 
then 
	read -p "Please enter the Koha database  host (e.g. db.foo.com / default localhost):" host 
	if test "`echo $host`" = ""
        then
                host='localhost'
        fi

	echo "ok - you entered: $host"
	echo

	read -p "Please enter the mysql database  port ( default 3306):" port 
	if test "`echo $port`" = ""
        then
                port='3306'
        fi

	echo "ok - you entered: $port"
	echo

	read -p "Please enter the database login (e.g.  koha_kohadev / default koha_library):" login
	if test "`echo $login`" = ""
        then
		login='koha_library'
	fi
	echo "ok - you entered: $login"
	echo

	read -s -p "Please enter the database password (hopefully no default like password):" passwd
	echo "ok - you entered: $passwd"
	echo

	read -p "Please enter the name database (default  koha_kohadev) :" datenbank 
	if test "`echo $datenbank`" = ""
	then
		datenbank='koha_kohadev'
	fi
	echo "ok - you entered: $datenbank"
	echo


#-------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------

cat > $CREDF <<_EOF_
<?php
\$db_host="$host";
\$db_port="$port";
\$db_login="$login";
\$db_password="$passwd";
\$db_name="$datenbank";
?>
_EOF_

chmod 550 $CREDF 


echo 
echo Testing DB Connection
echo
mysql --host="$host" --port=$port --user="$login" --password="$passwd" --database="$db_name" --execute='quit'


echo
echo

sleep 5

else 
	echo "Warning: $CREDF already exists. Will do take this..."
fi

#-------------------

