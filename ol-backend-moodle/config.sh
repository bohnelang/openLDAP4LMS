#!/bin/bash


if test "`dpkg -l | grep -i php-mysql`" = ""
then
        apt-get install php-db php-mysql  2> /dev/null > /dev/null
fi


echo "########################################################"
echo
echo "Config Moodle database access part:"
echo
echo

CREDF=credentialsx.php

if ! test -e $CREDF
then
        read -p "Please enter the Moodle database  host (e.g. db.foo.com / default localhost):" host
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

        read -p "Please enter the database login ( default moodleuser):" login
        if test "`echo $login`" = ""
        then
                login='moodleuser'
        fi
        echo "ok - you entered: $login"
        echo

        read -s -p "Please enter the database password:" passwd
        echo "ok - you entered: $passwd"
        echo

        read -p "Please enter the name database (default  moodle) :" datenbank
        if test "`echo $datenbank`" = ""
        then
                datenbank='moodle'
        fi
        echo "ok - you entered: $datenbank"
        echo

        read -p "Please enter the table  prefix as used in db like  mdl_user (default  mdl_) :" prefix
        if test "`echo $prefix`" = ""
        then
                prefix='mdl_'
        fi
        echo "ok - you entered: $prefix"
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
\$db_pref="$prefix";
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
