#!/bin/bash

##
##  This script updates the DNS of a dynamic host using a file written by an SSH session
##  v1.0 - 12 September 2016
##

CURRENT_IP="$(dig +short HOME_SERVER_HOSTNAME)"
RECORDED_IP="$(cat LOCATION_OF_IP_ADDRESS)"

### domain settings
DOMAIN="DOMAIN_NAME"
SUBDOMAIN="SUBDOMAIN"

### email message contents
EMAIL_ADDRESS="EMAIL_ADDRESS"
EMAIL_SUBJECT="[Success] Dynamic DNS update for HOSTNAME"
EMAIL_BODY="The dynamic DNS for $SUBDOMAIN.$DOMAIN has been updated. It now resolves to $RECORDED_IP"

  if [ "$CURRENT_IP" != "$RECORDED_IP" ]; then

    ## first delete the current entry and then add it again with the new IP - change this to
    ## update using dns -s "$DOMAIN" --list A,"$SUBDOMAIN","$RECORDED_IP"

    /usr/local/psa/bin/dns -d "$DOMIAN" -a "$SUBDOMAIN" -ip "$CURRENT_IP"
    /usr/local/psa/bin/dns -a "$DOMAIN" -a "$SUBDOMAIN" -ip "$RECORDED_IP"

    NEW_RESOLVED_IP="$(dig +short percy.oakland.lawrencelatif.com)"

    if [ "$RECORDED_IP" == "$NEW_RESOLVED_IP" ]; then

      ## successful update, send email saying this has happened, record some stats
      mail -s "$EMAIL_SUBJECT" "$EMAIL_ADDRESS" <<< "$EMAIL_BODY"

    fi

  fi