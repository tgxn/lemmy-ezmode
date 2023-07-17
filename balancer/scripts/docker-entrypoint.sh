#!/bin/sh

envsubst -i /template/traefik.template.yaml -o /etc/traefik/traefik.yaml

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
