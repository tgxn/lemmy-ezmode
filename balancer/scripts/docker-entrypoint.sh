#!/bin/sh

# if CLOUDFLARE_EMAIL is "" then we will use the default LE DNS Challenge
if [ ! -z "${CLOUDFLARE_EMAIL}" ];
then
    echo "Using Default DNS Challenge"
    envsubst -i /template/traefik.dns.yaml -o /etc/traefik/traefik.yaml
else
    echo "Using CloudFlare Challenge"
    envsubst -i /template/traefik.cloudflare.yaml -o /etc/traefik/traefik.yaml
fi

# cleanup logs
rm /logs/access.log | true
rm /logs/traefik.log | true

# template routes
cp /template/mgmt_routes.yaml /routes/mgmt_routes.yaml

echo "traefik config"
cat /etc/traefik/traefik.yaml

echo "mgmt routes"
cat /routes/mgmt_routes.yaml


exec traefik
