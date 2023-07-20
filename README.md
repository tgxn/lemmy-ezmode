[![test-stack](https://github.com/tgxn/lemmy-ezmode/actions/workflows/test.yaml/badge.svg)](https://github.com/tgxn/lemmy-ezmode/actions/workflows/test.yaml)

# Lemmy EZ-Mode

The idea here is you clone this repo, and configure your `.env` and then bring the compose stack online, and you should have a functioning lemmy instance.

There are a couple of ways to deploy Lemmy, I like deploying it using Traefik as the reverse proxy, I made this since the ansible template is hard to get running, and doesn't support Traefik.

Lemmy doesn't officially support Traefik, so I'm providing this as a place to start out getting it working.

I have added some really basic tests to make sure this stack always brings up a working container (at least in GitHub Workflows)

# Usage

1. Clone: `git clone https://github.com/tgxn/lemmy-ezmode.git`
2. Configure: Copy `.env.example` to `.env` and edit the values
3. Start: `docker-compose up -d`
4. Access: Visit the `LEMMY_BASE` URL

# Updating

1. Pull: `git pull`
2. Update: `docker-compose pull`
3. Recreate: `docker-compose up -d --build --force-recreate`

# Configuring

`config/lemmy.hjson` will be generated on the first run, or if one is not found in the config directory.

You can edit this file to configure your lemmy instance further.

There are also examples for SMTP in `docker-compose.override.example.yaml`
Make a copy of this file to `docker-compose.override.yaml`, then you can uncomment whichever SMTP service you want to use. Or even add your own custom services!

# Data / Backup

Back up the ./volumes directory, along with your `.env` and `config/lemmy.hjson` files.

That should be it. More complex backup scripts to come...

# Included Services

## Lemmy Services

- Traefik Balancer
 > Runs on port 80, and 443

- Lemmy & Lemmy-UI Server
 > These run on the docker network, and are not exposed to the host.

 ![Lemmy New Instance Page](./docs/images/lemmy-setup.png)

## Admin Services
These bind to local ports, and should only be accessible from your IPs.

**These are admin services, firewall them off to your IP only.**

- Traefik Admin Panel
 > Runs on port 81

![Traefik Admin Panel](./docs/images/traefik-panel.png)

- pgAdmin4 Container
 > Runs on port 82

![pgAdmin4 Admin Panel](./docs/images/pgadmin-panel.png)

# What/How

This uses a Traefik server to reverse proxy to the Lemmy server.
It uses the Traefik ACME challenge to automatically fetch and renew your certs.

You can optionally configure cloudflare credentials to automate SSL Certificate Verification with DNS.


# I want to add more servers to backend

Either

- add the container to the same network from this stack:
```yaml
networks:
  lemmy-traefik-net:
    external: true
```

- add manual config for the backend to `mgmt_routes.yaml`, you can use pgadmin as an example
    each backend will need one service (to tell traefik where the backend is) and one router (to tell traefik which traffic to send to the backend)

# I fucked up and want to reset everything

take the stack down, reset the repo, and rm any persistent volumes (this will WIPE ALL data)
```sh
docker-compose down
git reset --hard HEAD # optionally if you cloned this with git.
rm volumes/ -R
rm config/lemmy.hjson # if you want to reset lemmy config too
```

then update/edit your .env, and lemmy.hjson (if you didn't delete it) and you can try again:

```sh
docker-compose up -d
```