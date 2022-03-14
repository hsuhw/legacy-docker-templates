#!/bin/bash

# Start an one-off LDAP server for local connection

bash ./scripts/link_certs.sh

/container/tool/run --copy-service --loglevel debug &
sleep 5

# Set configs

readonly LDAPMODIFY_THIS='ldapmodify -H ldapi:/// -Y EXTERNAL'

${LDAPMODIFY_THIS} -f '/scripts/set_ppolicy_to_hash.ldif'
${LDAPMODIFY_THIS} -f '/scripts/set_passwd_hash_alg.ldif'

# Hash the passwords in SSHA512 and update the olcRootPW records

readonly adm_pass=$(slappasswd -h '{SSHA512}' -o 'module-path=/usr/lib/ldap' \
  -o 'module-load=pw-sha2' -s "${LDAP_ADMIN_PASSWORD}")
readonly conf_pass=$(slappasswd -h '{SSHA512}' -o 'module-path=/usr/lib/ldap' \
  -o 'module-load=pw-sha2' -s "${LDAP_CONFIG_PASSWORD}")
readonly esc_adm_pass=$(printf '%s\n' "${adm_pass}" | sed 's/[[\.*^$/]/\\&/g')
readonly esc_conf_pass=$(printf '%s\n' "${conf_pass}" | sed 's/[[\.*^$/]/\\&/g')

ldif=$(cat /scripts/update_root_passwd.ldif | \
  sed "s/__ADMIN_PASSWORD_HASH__/${esc_adm_pass}/" | \
  sed "s/__CONFIG_PASSWORD_HASH__/${esc_conf_pass}/")

${LDAPMODIFY_THIS} <<< "${ldif}"

# Update the userPassword record for admin user also

readonly base_dn="dc=$(echo "${LDAP_DOMAIN}" | sed "s/\./,dc=/g")"

ldif=$(cat /scripts/update_admin_passwd.ldif | \
  sed "s/__ADMIN_PASSWORD_HASH__/${esc_adm_pass}/" | \
  sed "s/__BASE_DN__/${base_dn}/")

ldapmodify -H ldapi:/// -D "cn=admin,${base_dn}" \
  -w "${LDAP_ADMIN_PASSWORD}" <<< "${ldif}"

# Add basic nodes into the directory

ldif=$(cat /scripts/add_basic_nodes.ldif | sed "s/__BASE_DN__/${base_dn}/")

ldapmodify -H ldapi:/// -D "cn=admin,${base_dn}" \
  -w "${LDAP_ADMIN_PASSWORD}" <<< "${ldif}"
