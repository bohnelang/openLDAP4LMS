logpasswd=passwoerter.txt
echo "" > $logpasswd


if test "`echo $inst`" = ""
then
        inst=/tmp/openldap4lms
fi

DPA=`openssl rand -base64 12  | base64 | cut -c 1-10`

echo 
echo
read -s -p "Plase enter a rootDN password (Default is $DPA):" dnpasswd
echo 
if test "`echo $dnpasswd`" = ""
then
	dnpasswd=$DPA
fi



DNPA=`$inst/sbin/slappasswd -s $dnpasswd `


cat S00ldap.template| sed s!"##CHDI##"!"$inst"!g > S00ldap 

cat slapd.conf.template | sed s!"##CHDI##"!"$inst"!g | sed s!"##CHME##"!"$DNPA"!g > slapd.conf

if test -e $inst/etc/openldap/server.pem
then
	echo "" 							>> slapd.conf
	echo "TLSCipherSuite HIGH:MEDIUM:+TLSv1:!SSLv2:+SSLv3"			>> slapd.conf		
	echo "TLSCACertificateFile  	$inst/etc/openldap/server.pem"	>> slapd.conf 
	echo "TLSCertificateFile  	$inst/etc/openldap/server.pem" 	>> slapd.conf
	echo "TLSCertificateKeyFile	$inst/etc/openldap/server.pem"	>> slapd.conf
fi 



echo "rootDN:  $dnpasswd $DNPA" >> $logpasswd

#---------------------------------------------------------------------------------------------------

unset PA 
PA=`openssl rand -base64 12  | base64 | cut -c 1-10`

echo
echo
read -s -p "Plase enter a query password (Default is $PA):" qpasswd
echo
if test "`echo $qpasswd`" = ""
then
        qpasswd=$PA
fi

QPA=`$inst/sbin/slappasswd -s $qpasswd `

cat unistruktur.ldif.template | sed s!"##libpasswd##"!"$QPA"!g >  unistruktur.ldif 

echo "query: $qpasswd $QPA" >> $logpasswd


kill `ps -eaf | grep slapd | awk {'print $2'}` 2> /dev/null

echo
echo
echo "Start openladap4lms"
echo
cp slapd.conf 		$inst/etc/openldap/
cp *.schema		$inst/etc/openldap/schema/
cp ldap.conf.template  	$inst/etc/openldap/ldap.conf
cp S00ldap 		$inst/etc/
cp ../openldap/openldap-2.3.32/servers/slapd/DB_CONFIG $inst/var/openldap-data
#############################################################################

echo
echo "Starting ldap://"
echo
$inst/etc/S00ldap start 
echo "$inst/etc/S00ldap start"
sleep 3 
ps -eaf | grep slap


if test -e $inst/etc/openldap/server.pem
then
	echo 
	echo "You can stop ldap and run secure ldap (ldaps) if you want: $inst/etc/S00ldap stop; $inst/etc/S00ldap sstart"	
	echo 
	sleep 3	
fi

sleep 5 


echo
echo
echo "Setting up a minimal ldap-tree ..."
echo
echo "$inst/bin/ldapadd -v -x -H ldap://localhost -D 'cn=superuser,dc=lms,dc=library' -w \"$dnpasswd\" -f unistruktur.ldif"
$inst/bin/ldapadd -v -x -H ldap://localhost -D 'cn=superuser,dc=lms,dc=library' -w "$dnpasswd" -f unistruktur.ldif

echo "------------------------------------------------------------------------ "
echo
echo
echo Test 
echo

#read -p "Please enter a test library ID:" libid
#echo "You entered $libid"
echo
echo

echo "$inst/bin/ldapsearch -v -x  -H ldap://localhost -D 'cn=query,dc=lms,dc=library' -w \"$qpasswd\"  -b 'dc=lms,dc=library' '(sn=Smith)'"
echo "$inst/bin/ldapsearch -v -x  -H ldap://localhost -D 'cn=query,dc=lms,dc=library' -w \"$qpasswd\"  -b 'dc=lms,dc=library' '(sn=Smith)'" > ldapsearch_example
echo " "  >> ldapsearch_example
echo "LDAPTLS_REQCERT=never $inst/bin/ldapsearch -v -x  -H ldaps://localhost -D 'cn=query,dc=lms,dc=library' -w \"$qpasswd\"  -b 'dc=lms,dc=library' '(sn=Smith)'" >> ldapsearch_example
$inst/bin/ldapsearch -v -x  -H ldap://localhost -D 'cn=query,dc=lms,dc=library' -w "$qpasswd"  -b 'dc=lms,dc=library' "(sn=Smith)"


echo "------------------------------------------------------------------------ "
echo 
echo "Summary"
echo "Start: $inst/etc/S00ldap start "
echo "Debug: $inst/etc/S00ldap debug "
echo "Stop: $inst/etc/S00ldap stop"
echo "Secure start: $inst/etc/S00ldap sstart "
echo "Secure debug: $inst/etc/S00ldap sdebug"
echo "Config in $inst/etc/openldap/slapd.conf"
echo
xhostname=`hostname -f` 
echo "Host: $xhostname"
echo "Protokoll: ldap:// (or ldaps:// with self signed certificate if started)" 
echo "Searchbase: dc=lms,dc=library"
echo "BindDN: cn=query,dc=lms,dc=library"
echo "Bind password: $qpasswd"
echo "Test entry: (sn=Smith)"
echo 
echo 
echo "------------------------------------------------------------------------ "
echo
echo "Do not forget to remove the ol-init/$logpasswd file with your password..."
echo
echo "There is a search example in ol-init/ldapsearch_example"
echo

echo 
