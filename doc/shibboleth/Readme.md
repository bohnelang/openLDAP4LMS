# openLDAP for library management systems 

## Shibboleth IDP

### Remarks

Due to the lack of a Shbboleth IDP server, this part is still no tested (Feb 2021). Feedback is appreciated.


### Use backend for Shibboleth
1. Uncomment in slapd.conf  /schema/eduperson.schema OR /dfneduperson.schema 
2. Create a one backend search_library_idp
3. Add to the search backend printf("objectClass: dfnEduPerson\n");
4. Map the LMS value to backend-output:  printf("dfnxyz: %s\n", $xyz);
5. Test Backend
6. Copy search_library_idp to openldap4lms/modules/
7. Add/substitute backend part like below in slapd.conf
7. Restart slapd
8. Follow e.g. https://doku.tid.dfn.de/de:shibidp:config-idm
9. Test LDAP connection
10. Done


```

Query with: user:cn=query,dc=lms,dc=library (like the other) 
and search in dc=idp,dc=lms,dc=library

# My library system
database                shell
suffix                  "dc=idp,dc=lms,dc=library"
search                  /tmp/openldap4lms/modules/search_library_idp
access to               dn.children="dc=idp,dc=lms,dc=library"
                        by dn.exact="cn=query,dc=lms,dc=library" read
#                       by peername=IP:147\.142\..+ read
readonly                yes
```
