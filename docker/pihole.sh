#!/bin/bash
# Functions that will launch docker containers

pihole() {
	if docker container ls 2>/dev/null | grep -q 'pihole'
	then
		echo "Stopping pihole..."
		docker container stop pihole
		docker container rm pihole
		echo "pihole stopped"
	else
		# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md 
		PIHOLE_BASE="${PIHOLE_BASE:-$(pwd)}"
		[[ -d "$PIHOLE_BASE" ]] || mkdir -p "$PIHOLE_BASE" || { echo "Couldn't create storage directory: $PIHOLE_BASE"; exit 1; }

		# Note: ServerIP should be replaced with your external ip.
		local P_DNS=$(next_port 53)
		local P_DHCP=$(next_port 67)
		local P_HTTP=$(next_port 80)
		local P_HTTPS=$(next_port 443)
		local TIMEZONE='America/New_York' # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
		local WEBPASSWORD='pipass'
		local EXTERNAL_IP=$(public_ip)
		
		printf "\nStarting up pihole container: http://localhost:${P_HTTP}\n\n"
		#printf "\nUsing Ports:\n\tDNS: ${P_DNS}\n\tHTTP: ${P_HTTP}\n\tHTTPS: ${P_HTTPS}\n\tDHCP: ${P_DHCP}\n\n"
		printf "\nUsing Ports:\n\tDNS: ${P_DNS}\n\tHTTP: ${P_HTTP}\n\tHTTPS: ${P_HTTPS}\n\n"

		# Required if you are using Pi-hole as your DHCP server, else not needed
		#    --publish ${P_DHCP}:67/udp
		#    --privileged
		docker run --detach \
		    --name pihole \
		    --publish ${P_DNS}:53/tcp \
		    --publish ${P_DNS}:53/udp \
		    --publish ${P_HTTP}:80/tcp \
		    --publish ${P_HTTPS}:443/tcp \
		    --volume "${PIHOLE_BASE}/etc-pihole/:/etc/pihole/" \
		    --volume "${PIHOLE_BASE}/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
		    --dns=127.0.0.1 \
		    --dns=1.1.1.1 \
		    --restart=unless-stopped \
		    --hostname pi.hole \
		    --env VIRTUAL_HOST="pi.hole" \
		    --env PROXY_LOCATION="pi.hole" \
		    --env PIHOLE_DNS_="127.0.0.1#5353;8.8.8.8;8.8.4.4;1.1.1.1" \
		    --env TZ=${TIMEZONE} \
		    --env ServerIP=${EXTERNAL_IP} \
		    --env WEBPASSWORD=${WEBPASSWORD} \
		    --restart=unless-stopped \
		    --cap-add=NET_ADMIN \
		    pihole/pihole:latest

		sleep 10
		wait

		for i in $(seq 1 20); do
		    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
		        printf ' OK'
		        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
		        return 0
		    else
		        sleep 3
		        printf '.'
		    fi

		    if [ $i -eq 20 ] ; then
		        echo -e "\nTimed out waiting for Pi-hole start, consult your container logs for more info (\`docker logs pihole\`)"
		        return 1
		    fi
		done;
	fi
}

