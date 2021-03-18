# openLDAP for library management systems 

### Sometimes it would be nice if library staff could directly fetch email addesses from library management systems (LMS)  within a mail program like Outlook or Thunderbird by LDAP query. 
### In addition to this function it would be nice if LMS could directly serve as your IDM (IDentity Management) for Shibboleth IDP (IDentity Provider) or other systems. 

**Keywords**: LMS, LDAP, backend, data export, ALMA, SISIS Sunrise, PAIA, FOLIO, Outlook, Thunderbird, Apple Mail, Shibboleth, IDP, IDM




![Concept survey](https://raw.githubusercontent.com/bohnelang/openldap4lms/master/doc/graphics/Bild1a.jpg)

#### Use openLDAP to answer the LDAP request:
![Concept fine](https://raw.githubusercontent.com/bohnelang/openldap4lms/master/doc/graphics/Bild2.jpg)

#### Solution:
![Concept fine](https://raw.githubusercontent.com/bohnelang/openldap4lms/master/doc/graphics/Bild3.jpg)

#### Example: ALMA LMS Sandbox:
![Concept fine](https://raw.githubusercontent.com/bohnelang/openldap4lms/master/doc/client/Folie10.jpg)


## Introduction:
In 2007 I developed an openLDAP shell backend that implements the functionality to fetch data from library management systems (LMS) and transform them to LDAP standard format.  Recently I stumbled over this possibly outdated program code, but found itstill  as  useful as to publish this project. I decided to write a general skeleton shell backend that can be filled with program code for different LMS. You need to fetch the data from your LMS and map it to the official LDAP attributes. The skeleton I add is an executable demo written in php and just fills 3 data records. Additionally I add some working examples of leading library management systems. 


## Some LMS backends examples:
- **Skeleton/Demo**: Static data record to demonstrate functionality
   - Search: lastname
   - Tested: ready to use
   - Demo available: native (search for "Smith")
- **FOLIO**: Retrieval via API
   - Search: lastname (wildcard), username (wildcard) or  barcode
   - Demo/Testserver available: yes (online demo server, serach for "Smith" or  "Kuhlman")
   - Tested (with demo system): ready to use
- **ALMA**: Login via  RESTful API and API-Key
   - Search: lastname (wildcard) and primary_id
   - Demo/Testserver available: yes (online sandbox, search for "Smith") 
   - Tested (with demo system): ready to use
- **SISIS Sunrise**: Retrieval via Sybase DB-login (with freeTDS) and SQL
   - Search: lastname (wildcard) or user-ID (Benutzernummer) 
   - Demo/Testserver available: no 
   - Tested (with real system): ready to use
- **KOHA**: Retrieval via MySQL DB-login
   - Search: lastname (wildcard), cardnumber or userid
   - Demo/Testserver available: no
   - Tested: Beta - should work.
- **PAIA-API**: Patrons Account Information API - need a special patron login with client credentials (this is not a normal login)
   - Search: Patron identifier 
   - Demo/Testserver available: not public (on demand)
   - Tested (with GBV demo system): ready to use
- **WMS**: not yet developed
- **Other systems**: not yet developed

- **Moodle**: Although moodle is a learning managment system (and not library managment system), an implementation was easy. Have a try :-)


## Remarks:
This  project is using outdated versions of openssl and openldap 2.3. Nevertheless I decided to publish this project, as openldap in version 2.3 is the last version using a real config file that is easy to understand. This issue makes it much easier for newbies and IT librarians to have success and understand what they are doing.  Using openldap 2.4 the configuration of the openldap server is located in the openldap server itself (in a separate config tree). Every modification has to be performed by ldapadd, ldapmodify, or ldapdelete command, or you need to export and import config part. This procedure is a great challenge for people who are not familiar with administrating an openldap system. Thus keep in your minds: These sources are outdated, but it is nice to have a working system/demo. 



##  Migrate config file from openLDAP 2.3 to uptodate openLDAP 2.4
If you have understood how it works and found your working config settings (for developing a working config file openldap 2.3 is strongly recommended), you can upgrade to openldap 2.4. All distibutions do have an uptodate openLDAP packague in their repositories. To upgrade from the version 2.3 config file to version 2.4 is not difficult and there are some good tutorials on the net like [Converting old slapd.conf file to cn=config format](https://www.sbarjatiya.com/notes_wiki/index.php/Converting_old_slapd.conf_file_to_cn%3Dconfig_format).
Keep in mind that you are using this service in a trustworthy environment  - normally your library LAN and often in intranet no secure protocol is neccessary. 


## Run / Test System
### Required IT skills:
- *Install system*: low 
- *Run demo*: low 
- *Change to productivity* e.g. with a meta LDAP: medium 
- *Development own backend*: low - medium - high (depending on your LMS/system)


### System requirements:
- Small Linux System (bare metal or better VM)
- Preferred: Ubuntu 18 LTS (when using other Linux distributions YOU must take care for depedencies and package manager - this is not complicated: apt-get -> pacman, emerge, zypper, rpm, etc...)
- Free network access to your target system (LMS)
- Free network access from client to this system on port 389 (ldap://) and/or on port 636 (ldaps://)

### Install & Run
*General:*
This demo is running in default directory /tmp/openldap4lms/. Thus the path indications in this text refer to this path. You can choose a path you like while installation. 

Download sources from git and go into the directory and compile all by ./make_all.sh
- git clone https://github.com/bohnelang/openldap4lms/
- cd openldap4lms
- ./make_all.sh 
- and follow the instructions

When done, the script starts openldap server and instructs you. 

------------

The openLDAP can run using
- /tmp/openldap4lms/etc/S00ldap start  - Normal mode - ldap://
- /tmp/openldap4lms/etc/S00ldap sstart - Secure mode - ldaps://
- /tmp/openldap4lms/etc/S00ldap debug  - Debug mode - ldap://
- /tmp/openldap4lms/etc/S00ldap sdebug - Secure debug mode - ldaps://
- /tmp/openldap4lms/etc/S00ldap stop   - Stop daemon 

The default is 'normal mode' with ldap:// protocol. 

This demo can not run  'normal mode' and 'secure mode' in parallel. Before you switch to secure mode, test the normal mode.  

*Secure mode:*
The openLDAP server is prepared for ldaps:// protocol. Therefore a self-signed certificate is used. A self-signed certificate is weak and normally rejected by the client - thus run shell client with LDAPTLS_REQCERT=never like this:
```
LDAPTLS_REQCERT=never /tmp/openldap4lms/bin/ldapsearch -v -x  -H ldaps://localhost -D 'cn=query,dc=lms,dc=library' -w "clFvdTNaaV"  -b 'dc=ldap,dc=lms,dc=library' '(sn=Smith*)'
```
You can create a certificate for your openLDAP server and can let it sign by your CA. 

My advice:  use "normal mode" and not "secure mode" during the start phase.


## [Client (Outlook, Thunderbird, etc.) Integration](https://github.com/bohnelang/openldap4lms/blob/master/doc/client/Readme.md)




## Included Schemas: 
- Core:
  - core.schema
  - cosine.schema
  - inetorgperson.schema 
- Mail 
  - officeperson.schema 	// Outlook
  - thunderbird.schema 	// Thunderbird
- Shibboleth IDP (support ready) :
  - ndslogin.schema      // expire date
  - eduperson.schema 
  - dfneduperson.schema
- Login/Password systems (?)
  - nis.schema






## MetaLDAP or cascading LDAP
Normally mail programs can handle one LDAP entry only. If you want to provide a LDAP service for staff (!) with normal address LDAP and LMS data together, you can find in the slapd.conf a comment section with an example of such a configuration:

```
mail program <-staff only-> openldap4lms <-+-> official address LDAP
                                           |
                                           +-> Library Management System (LMS) 
```

```
The  MetaLDAP is queried with: dc=lms,dc=library

slapd.conf interesting part of this :



#LDAP (your organization LDAP):
database               ldap
uri                    ldap://ldap.foo.com
suffix                 "dc=outerldap,dc=lms,dc=library"
rwm-suffixmessage      "dc=outerldap,dc=lms,dc=library" "dc=addressbook,dc=foo,dc=com"
subordinate
(...)

#LMS
database                shell
suffix                  "dc=innerldap,dc=lms,dc=library"
subordinate
(...)

Both backends are situated beneath dc=lms,dc=library and a request to dc=lms,dc=library searches in dc=outerldap,dc=lms,dc=library AND dc=ldap,dc=lms,dc=library.

dc=lms,dc=library
    |
    +--> dc=outerldap,dc=lms,dc=library
    |
    +--> dc=innerldap,dc=lms,dc=library
```


## [Development / Debug / Troubleshootung](https://github.com/bohnelang/openldap4lms/blob/master/doc/development/Readme.md)

## [Shibboleth IDP](https://github.com/bohnelang/openldap4lms/blob/master/doc/shibboleth/Readme.md)


## Acknowledgment: 
**Loads of thanks to**
- PAIA  (GBV - Gemeinsamer Bibliotheksverbund): *Magdalena Roos, Jürgen Hofmann, Jakob Voß*
- FOLIO (hbz - Hochschulbibliothekszentrum NRW):  *Ingolf Kuss, Meike Osters*
- KOHA (TH-Köln): *Simon Brenner*

## Glossary:
- LMS: Library Management System
- LIS: Library Information System
- IDP: Identity Service Provider
- IDM: Identity Management System
- LDAP: Lightweight Directory Access Protocol 
- FOLIO: The Future of Libraries is Open. A free LMS.
- ALMA: Cloud-based LMS from Ex Libris Alma
- KOHA: A free LMS
- OCLC: Online Computer Library Center. A non-profit organisation for libraries from US. 
- SISIS: Siemens-Sinix-Informationssysteme. The full Name 'SISIS Sunrise' from OCLC. An LMS.
- WMS: WorldShare Management Services. A cloud-based LMS from OCLC
- PAIA: Patrons Account Information



## Changelog:
- ...

## ToDo list:
- Find someone who tests Shibboleth implementation. 
- Folio cannot work with CQL queries although they should work


