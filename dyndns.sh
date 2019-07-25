#!/bin/sh

# set parameters to your needs
USERNAME="USERNAME"
CLIENTKEY="CLIENTKEY"
PUBLIC_IP4_LOOKUP_SERVICE="ip4.dnshome.de"

# Set constants
IPCACHEv4="/var/tmp/ipcachev4"
IPCACHEv6="/var/tmp/ipcachev6"

# Get public ipv4 address from service
IP4ADDR=$(curl -s --show-error $PUBLIC_IP4_LOOKUP_SERVICE | grep -o "[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}.[0-9]\{1,3\}")

# Get global unicast ipv6 address from interface
IP6ADDR=$(ip -6 addr | awk '{print $2}' | grep -P '^(?!fd)^(?!fe80)^(?!fc)[[:alnum:]]{4}:.*/64' | cut -d '/' -f1 | head -1 | tr -d '\n')

# get old ip addresses if available 
. "$IPCACHEv4" 2> /dev/null
. "$IPCACHEv6" 2> /dev/null

# check if current unicast ipv6 address is available
if [ "$IP6ADDR" = "" ]
then
        echo "Error: unable to determine IPv6 address"
else
	# update ipv6 if changed
	if [ "$IP6ADDR" != "$OLDIP6ADDR" ]
	then
		# adjust update URL to your needs
        	curl -s --show-error  -u "$USERNAME:$CLIENTKEY" "https://www.dnshome.de/dyndns.php?ip6=$IP6ADDR"
        	echo "OLDIP6ADDR=\"$IP6ADDR\"" > "$IPCACHEv6"
	fi
fi

# check if current public ipv4 address is available
if [ "$IP4ADDR" = "" ]
then
        echo "Error: unable to determine IPv4 address"
else
        # update ipv4 if changed
        if [ "$IP4ADDR" != "$OLDIP4ADDR" ]
        then
                # adjust update URL to your needs
                curl -s --show-error -u "$USERNAME:$CLIENTKEY" "https://www.dnshome.de/dyndns.php?ip=$IP6ADDR"
                echo "OLDIP4ADDR=\"$IP4ADDR\"" > "$IPCACHEv4"
        fi
fi
