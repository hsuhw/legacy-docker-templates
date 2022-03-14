# A Template for Dockerized OpenLDAP

- Base image: Debian 8.5
- OpenLDAP version: 2.4.40

### A SSSD Client Configuration Example on CentOS 7

1) If you are using a self-created CA, place its pem file to the
   openldap client `cacerts` DIR and add the following line to its
   config file `/etc/openldap/ldap.conf`.

```
TLS_CACERT   /etc/openldap/cacerts/<my-ca-name>.pem
```

2) Make sure that `sssd` and `authconfig` are installed.  The package
   dependencies should look something like this:

```
sssd-client
sssd-common
sssd-common-pac
sssd-ldap
sssd-proxy
python-sssdconfig
authconfig
authconfig-gtk
```

3) Check the current settings for `sssd` if any:

```
authconfig --test
```

This will show the settings already in place.  If you just got it
installed, everything is usually disabled.

4) Configure `sssd` with:

```
authconfig \
--enablesssd \
--enablesssdauth \
--enablelocauthorize \
--enableldap \
--enableldapauth \
--ldapserver=ldap://ldap.example.com \
--disableldaptls \
--ldapbasedn=dc=example,dc=com \
--enablemkhomedir \
--enablecachecreds \
--update
```

Then modify the configuration file `/etc/sssd/sssd.conf`.  It should at
least contain these settings:

```
[sssd]
services = nss, pam, ssh
config_file_version = 2
domains = LDAP

[domain/LDAP]
debug_level = 6
id_provider = ldap
auth_provider = ldap
access_provider = ldap
chpass_provider = ldap
ldap_uri = ldaps://ldap.example.org
cache_credentials = True
ldap_default_bind_dn = __LDAP_CLIENT_USER__
ldap_default_authtok = __LDAP_CLIENT_USER_PASSWORD__
ldap_search_base = dc=example,dc=org
ldap_user_search_base = ou=Users,dc=example,dc=org
ldap_user_ssh_public_key = sshPublicKey
ldap_group_search_base = ou=POSIX Groups,dc=example,dc=org
ldap_access_filter = memberOf=cn=Active Members,ou=Groups,dc=example,dc=org
```

You can also get it done with an existing `/etc/sssd/sssd.conf` file, but
running the `authconfig` command first is still desirable since it will
help you deal with the settings of other auth-related packages in the system.

Restart sssd when you are done to realize these changes:

```
systemctl restart sssd
```

You can now check again to make sure they have been loaded correctly:

```
authconfig --test
```

6) Make sure that `sssd` is up and running, and enabled to restart
   automatically when the system reboots.  Use `systemctl status sssd`
   to check.

### Using Apache Directory Studio to Manually Edit the Directory

The functions Apache DS provides are generally fine while some bugs
exists.  To work around with them:

- Choose JNDI as the driver when creating the connection in the creation
  wizard to prevent the TLS connection freeze (if any).
- Use, for example, JXplorer's certificate explorer to manage the
  keystore of its trusted certificates if it is desired; there is a
  `NullPointerException` bug in its built-in explorer.
