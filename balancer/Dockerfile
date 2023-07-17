FROM byrnedo/alpine-curl:latest AS download

# install envsubst
RUN mkdir /work
RUN curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-Linux-x86_64 -o /work/envsubst
RUN chmod +x /work/envsubst

FROM traefik:latest

COPY --from=download /work/envsubst /usr/local/bin/envsubst

RUN mkdir /etc/traefik/

RUN mkdir /certs
RUN mkdir /routes

COPY ./scripts/ /usr/local/bin/
COPY ./template/ /template/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
