# openLDAP for library management systems 

## Development / Debug / Troubleshooting

![Dataflow](https://raw.githubusercontent.com/bohnelang/openLDAP4LMS/master/doc/graphics/Folie2.JPG)


### Developing openLDAP shell backend
The openLDAP backend 'shell' can launch any executable program, such as a native compiled C program, or a bash, or php or python script. The communication is done via the stdin and stdout channel. You can return the data in plain ASCII or, if there are any special characters within names, you can encode the data in base64. The ":": indicates that the data is base64 encoded. 

normal entry:
sn: Lang

base64 encoded entry:
sn:: TGFuZw==

### Troubleshooting/Debugging:
While developing I noticed that openLDAP server is quite sensitive like a mimosa. If you are doing changes - run the openLDAP server in debug mode. With google and patience you will fix any problem :)

The binary build of this demo uses the linker parameter -rpath - thus you cannot 'simply' move this openldap installation into another directory that is different to the one you entered while installation. On the other side you do not change PATH or LD_LIBRARY environment variable for running. 

```
Example for debugging the backend shell and your program - start in debug mode 1024:
(See https://www.openldap.org/doc/admin24/guide.html)

Debugging Levels Level 	Keyword 	Description
   -1 	any 	         enable all debugging
    0  	no debugging
    1 	(0x1 trace)     trace function calls
    2 	(0x2 packets)   debug packet handling
    4 	(0x4 args)      heavy trace debugging
    8 	(0x8 conns)     connection management
   16 	(0x10 BER)      print out packets sent and received
   32 	(0x20 filter)   search filter processing
   64 	(0x40 config)   configuration processing
  128 	(0x80 ACL)      access control list processing
  256 	(0x100 stats)   stats log connections/operations/results
  512 	(0x200 stats2) 	stats log entries sent
 1024 	(0x400 shell)   print communication with shell backends
 2048 	(0x800 parse)   print entry parsing debugging
16384 	(0x4000 sync)   syncrepl consumer processing
32768 	(0x8000 none)   only messages that get logged whatever log level is set 

Thus call it with: /tmp/openldap4lms/libexec/slapd -d 1024 &
 
then run a search test:
 /tmp/openldap4lms/bin/ldapsearch -v -x  -H  ldap://localhost -D 'cn=query,dc=lms,dc=library' -w "clFvdTNaaV"  -b 'dc=lms,dc=library' '(sn=Mysteri)'

this will output something like this:
ldap_initialize( ldap://localhost )
filter: (sn=Mysteri)
requesting: All userApplication attributes
# extended LDIF
#
# LDAPv3
# base <dc=lms,dc=library> with scope subtree
# filter: (sn=Mysteri)
# requesting: ALL
#

shell search reading line (dn: cn=501224,dc=ldap,dc=lms,dc=library)
shell search reading line (objectClass: top)
shell search reading line (objectClass: person)
shell search reading line (objectClass: organizationalPerson)
shell search reading line (objectClass: inetOrgPerson)
shell search reading line (objectClass: mozillaAddressBookEntry)
shell search reading line (objectClass: officePerson)
shell search reading line (objectClass: ndsLoginProperties)
shell search reading line (cn:: NTAxMjI0)
shell search reading line (sn:: TXlzdGVyaQ==)
shell search reading line (givenName:: RXZl)
shell search reading line (mail: eve@myst.test)

(...) 
```

### During the development phase run script/program manually like this:
```
./search_library <<_EOF_
SEARCH
msgid: 2
suffix: dc=lms,dc=library
base: dc=lms,dc=library
scope: 2
deref: 0
sizelimit: 500
timelimit: 3600
filter: (&(objectClass=*)(|(cn=smith*)(mail=smith*)(sn=smith*)))
attrsonly: 0
_EOF_
```


![Mail Attribute](https://raw.githubusercontent.com/bohnelang/openldap4lms/master/doc/graphics/Folie3.JPG)


### Background: Typical LDAP filter queries from mail programs:
```
- Thunderbird
 
 - Addressbook:(&(objectClass=*)(&(|(cn=*smith*)(givenName=*smith*)(sn=*smith*)(mozillaNickname=*smith*)(mail=*smith*)(mozillaSecondEmail=*smith*)(&(description=*smith*))(o=*smith*)(ou=*smith*)(title=*smith*)(?=undefined)(?=undefined))))
 
- Outlook
 - Addressbook: (&(|(mail=smith*)(cn=smith*)(sn=smith*)(givenName=smith*)(displayName=smith*)))
   SRCH attr=cn commonName mail roleOccupant display-name displayname sn surname co organizationName o givenName legacyExchangeDN objectClass uid mailNickname title company physicalDeliveryOfficeName telephoneNumber



 - To-Line: (&(objectClass=*)(|(cn=smith*)(mail=smith*)(sn=smith*)))



```
