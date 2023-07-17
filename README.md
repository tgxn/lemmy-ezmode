# Lemmy EZMode

I made this since the ansible template is hard to get running.

 > The idea here is you clone this repo, and configure your `.env` and then bring the compose stack online, and you should have a functioning lemmy isntance.

This uses Traefik Reverse proxy to fetch and renew your certs, local directories for data persistency, and sane defaults.

# Usage

1. Clone this repo: `git clone https://github.com/tgxn/lemmy-ezmode.git`
2. Copy `.env.example` & configure `.env` file.
3. Run `docker-compose up -d` or `docker compose up -d`
4. ???
5. Access on `LEMMY_BASE` URL
6. Profit...

**Traefik dashboard will run on :81, firewall this off to your IP only.**

# What/How

This uses a Traefik server to reverse proxy to the Lemmy server.
It also uses the Traefik ACME challenge to automatically fetch and renew your certs.

## Advanced

@TODO

If you have your own Traefik server, you can use the `docker-compose.own-traefik.yaml` to use docker labels to instead setup the proxy
