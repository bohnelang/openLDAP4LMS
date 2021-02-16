#!/bin/bash


if test "`dpkg -l | grep -i odbc`" = ""
then
        apt-get install php-db php-odbc tdsodbc unixodbc freetds-bin  2> /dev/null > /dev/null
fi

if ! test -e /usr/lib/x86_64-linux-gnu/odbc/libodbccr.so
then
	ln -s /usr/lib/x86_64-linux-gnu/libodbccr.so.2.0.0 /usr/lib/x86_64-linux-gnu/odbc/libodbccr.so
fi


echo "########################################################"
echo 
echo "Config Sisis Sunrise Sybase part:"
echo
echo 

CREDF=credentialsx.php

if ! test -e $CREDF 
then 
	read -p "Please enter the Sybase host (e.g. localhost or sisis.medma.uni-heidelberg.de):" host 
	echo "ok - you entered: $host"
	echo

	read -p "Please enter the Sybase port (e.g. 4000 or 5000 / default 4000):" port 
	if test "`echo $port`" = ""
        then
                port='4000'
        fi

	echo "ok - you entered: $port"
	echo

	read -p "Please enter the database login (e.g. sisis / default sisis):" login
	if test "`echo $login`" = ""
        then
		login=sisis
	fi
	echo "ok - you entered: $login"
	echo

	read -s -p "Please enter the database password:" passwd
	echo "ok - you entered: $passwd"
	echo

	read -p "Please enter the sisis database (default sisis) :" datenbank 
	if test "`echo $datenbank`" = ""
	then
		datenbank='sisis'
	fi
	echo "ok - you entered: $datenbank"
	echo


#-------------------------------------------------------------------------------------


F=/etc/freetds/freetds.conf
if  test -e $F 
then
	if  test "`cat  $F| grep ^\[Sisis]`" = ""
	then
	cat >>  $F <<_EOF_
# Sybase DB 15 Sisis
[Sisis]
        host = $host 
        port = $port 
        tds version = 6.0
        text size = 64512
        client charset = UTF-8
_EOF_

	else 
		echo "$F exists and Sisis ist configured - update setting manually. This script $F is not updated."
	fi
fi
echo "Config file: $F"

#-------------------------------------------------------------------------------------

F=/etc/odbc.ini
if  test -e $F 
then
	if test "`cat $F | grep ^\[Sisis] `" = ""
	then
	cat >>  $F <<_EOF_
[Sisis]
Description = Sisis Bibliotheksystem
Driver = FreeTDS # Same as identifier in odbcinst.ini
Database = $datenbank # Not instance, database within the instance
ServerName = Sisis # This  is the same identifier as in freetds.conf
_EOF_
	else
               echo "$F exists and Sisis ist configured - update setting manually. This script $F is not updated."

	fi
else
       cat >  $F <<_EOF_
[Sisis]
Description = Sisis Bibliotheksystem
Driver = FreeTDS # Same as identifier in odbcinst.ini
Database = $datenbank # Not instance, database within the instance
ServerName = Sisis # This  is the same identifier as in freetds.conf
_EOF_

fi
echo "Config file: $F"


#-------------------------------------------------------------------------------------

F=/etc/odbcinst.ini
if  test -e $F 
then
	if test "`cat $F | grep ^\[FreeTDS] `" = "" 
	then
        cat >>  $F <<_EOF_
[FreeTDS] # This is your identifier! You'll need it in odbc.ini
Description = FreeTDS Driver
Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so 
Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so
fileusage=1
dontdlclose=1
UsageCount=1
_EOF_
	else
                echo "$F exists and Sisis ist configured - update setting manually. This script $F is not updated."

	fi
else
        cat >  $F <<_EOF_
[FreeTDS] # This is your identifier! You'll need it in odbc.ini
Description = FreeTDS Driver
Driver = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so 
Setup=  /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so
fileusage=1
dontdlclose=1
UsageCount=1
_EOF_

fi 
echo "Config file: $F"

#-------------------------------------------------------------------------------------

cat > $CREDF <<_EOF_
<?php
# /etc/freetds/freetds.conf
# /etc/odbcinst.ini
# /etc/odbc.ini
\$db_tdbs_con = "Sisis";
\$db_login="$login";
\$db_password="$passwd";
\$db_zweigstelle="00";
\$db_name="$datenbank";
?>
_EOF_

chmod 550 $CREDF 


echo 
echo Testing DB Connection
echo
osql -S Sisis -U $login -P "$passwd"
echo
echo

sleep 5

else 
	echo "Warning: $CREDF already exists. Will do take this..."
fi

#-------------------

