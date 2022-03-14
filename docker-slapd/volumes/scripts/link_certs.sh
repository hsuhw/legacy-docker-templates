#!/bin/bash

readonly CERT_VOL='/container/service/slapd/assets/certs'

ln -fs "/cert/${LDAP_TLS_CRT_FILENAME}" "${CERT_VOL}/${LDAP_TLS_CRT_FILENAME}"
ln -fs "/cert/${LDAP_TLS_KEY_FILENAME}" "${CERT_VOL}/${LDAP_TLS_KEY_FILENAME}"
ln -fs "/cert/${LDAP_TLS_CA_CRT_FILENAME}" "${CERT_VOL}/${LDAP_TLS_CA_CRT_FILENAME}"
ln -fs '/cert/dhparam.pem' "${CERT_VOL}/dhparam.pem"
