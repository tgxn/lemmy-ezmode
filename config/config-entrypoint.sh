#!/bin/sh

# Install Config with Variables from ENV
cat >/config/config.hjson <<EOL
{
    database: {
      host: postgres
      password: "POSTGRES_PW"
      pool_size: 25
    }
    hostname: "BASE_URL"
    port: 8536,
    pictrs: {
      url: "http://pictrs:8080/"
      api_key: "PICTRS_API_KEY"
    }
}
EOL

sed -i "s/POSTGRES_PW/$POSTGRES_PASS/g" /config/config.hjson
sed -i "s/BASE_URL/$LEMMY_DOMAIN/g" /config/config.hjson
sed -i "s/PICTRS_API_KEY/$PICTRS_API_KEY/g" /config/config.hjson

cat /config/config.hjson

/app/lemmy
