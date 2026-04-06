#!/bin/sh

# collect_google_ip_addresses.sh
#
# Dynamically creates a list of IP addresses with their CIDR notation used by Google Corp's netblocks.
#
# 20210218 - WirelessPhreak and ToddiBear

# Check that dig is available
if ! command -v dig > /dev/null 2>&1; then
    echo "Error: 'dig' is not installed or not in PATH." >&2
    exit 1
fi

google_netblocks="_netblocks.google.com _netblocks2.google.com _netblocks3.google.com _spf.google.com _cloud-netblocks1.googleusercontent.com _cloud-netblocks2.googleusercontent.com _cloud-netblocks3.googleusercontent.com _cloud-netblocks4.googleusercontent.com _cloud-netblocks5.googleusercontent.com"
ip_address_file="./GoogleIPs.txt"

# Collect IPv4 addresses
ipv4_addresses=$(dig -t txt $google_netblocks +short \
    | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])/([0-9]|[1-2][0-9]|3[0-2])')

# Collect IPv6 addresses
ipv6_addresses=$(dig -t txt $google_netblocks +short \
    | grep -oE '([0-9a-fA-F:]+:+[0-9a-fA-F]*)/[0-9]{1,3}')

# Combine, sort, and deduplicate
all_addresses=$(printf '%s\n%s\n' "$ipv4_addresses" "$ipv6_addresses" \
    | grep -v '^$' | sort -u)

if [ -z "$all_addresses" ]; then
    echo "Error: No IP addresses collected. DNS queries may have failed." >&2
    exit 1
fi

# Write the Google Corp IP addresses to a file
echo "$all_addresses" > "$ip_address_file"

echo "Collected $(echo "$all_addresses" | wc -l | tr -d ' ') IP ranges and saved to $ip_address_file"
