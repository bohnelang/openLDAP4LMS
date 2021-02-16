#!/bin/bash
# Aufruf z.B. ./queryUserFolioDemo.sh personal.lastName==Mustermann
# oder ./queryUserFolioDemo.sh personal.lastName=Kuhlman https://folio-demo.gbv.de/okapi
# Ingolf Kuss -  hbz - Hochschulbibliothekszentrum NRW

USERNAME="diku*"
if [ -n "$1" ]; then USERNAME=$1; fi
OKAPI=https://folio-demo.hbz-nrw.de/okapi
if [ -n "$2" ]; then OKAPI=$2; fi
TENANT="diku";

TOKEN=$( curl -s -S -D - -H "X-Okapi-Tenant: $TENANT" -H "Content-type: application/json" -H "Accept: application/json" -d '{ "tenant" : "diku", "username" : "diku_admin", "password" : "admin" }' $OKAPI/authn/login | grep -i "^x-okapi-token: " )

curl -s -S -X GET -H "$TOKEN" -H "X-Okapi-Tenant: $TENANT" -H "Content-type: application/json; charset=utf-8" -H "Accept: application/json" $OKAPI/bl-users?query=username=$USERNAME

