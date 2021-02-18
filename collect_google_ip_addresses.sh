#!/bin/sh

# collect_google_ip_addresses.sh
#
# Dynamically creates a list of IP address with their CIDR notation use by Google Corp's netblocks.
#
# 20210218 - WirelessPhreak and ToddiBear

recaptcha_netblocks="_netblocks.google.com _netblocks3.google.com"
# Collects the Google Corp IP addresses and their CIDR notation from Google's netblocks
ip_addresses=`dig -t txt $recaptcha_netblocks +short | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])/[0-9][0-9]?'`
ip_address_file=./GoogleIPs.txt
git commit ./GoogleIPs.txt -m 'commit via automated script'

# Write the Google Corp's IP addresses to a file
echo "$ip_addresses" > $ip_address_file
