#!/bin/bash

#enable job control in script
set -e -m

#####   variables  #####

# add command if needed
if [ "${1:0:1}" = '-' ]; then
  set -- slapd "$@"
fi

#run command in background
if [ "$1" = 'slapd' ]; then
  ##### pre scripts  #####
  echo "========================================================================"
  echo "initialize:"
  echo "========================================================================"
  sed -i "s|{{ LDAP_URI }}|${LDAP_URI}|g"         /etc/ldap/ldap.conf
  sed -i "s|{{ LDAP_SUFFIX }}|${LDAP_SUFFIX}|g"   /etc/ldap/ldap.conf
  sed -i "s|{{ LDAP_BIND_DN }}|${LDAP_BIND_DN}|g" /etc/ldap/ldap.conf
  sed -i "s|{{ LDAP_BIND_PW }}|${LDAP_BIND_PW}|g" /etc/ldap/ldap.conf

  ##### run scripts  #####
  echo "========================================================================"
  echo "startup:"
  echo "========================================================================"
  exec "$@" &

  ##### post scripts #####
  echo "========================================================================"
  echo "configure:"
  echo "========================================================================"

  #bring command to foreground
  fg
else
  exec "$@"
fi