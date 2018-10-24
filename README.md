# Docker Murmur

This is a Docker image for the Mumble server, Murmur. Server is installed from the Ubuntu 18.04 package repository. The container is equipped with an ACME client that is capable of automatically generating trusted SSL certificates using DNS verification.

## Usage

Just run the container with forwarded ports and you are done!

```sh
docker run -d --name murmur -p 64738:64738 -v mumble-data:/var/lib/mumble-server kadimasolutions/murmur
```

This will start the Mumble server and persist its data in the named volume `mumble-data`.

You can also use Docker Compose:

```yaml
version: '3'
services:
  murmur:
    image: kadimasolutions/murmur:latest
    ports:
     - 64738:64738
    volumes:
     - mumble-data:/var/lib/mumble-server

volumes:
  mumble-data:
```

## Configuring Mumble

All mumble settings can easily be set through environment variables. All that is necessary is to prepend `MUMBLE_` to the name of a mumble setting and set that environment variable.

You can set the SuperUser password with the `SUPERUSER_PASSWORD` environment variable. If you do not set the SuperUser password, it will be set to a random password that you can find in the container logs.

```yaml
version: '3'
services:
  murmur:
    image: kadimasolutions/murmur:latest
    ports:
     - 64738:64738
    environment:
      SUPERUSER_PASSWORD: supersecretpassword
      # Disable Bonjour
      MUMBLE_bonjour: "False"
      # Set welcome text
      MUMBLE_welcometext: <br />Welcome to this server running <b>Murmur in Docker</b>!<br />Enjoy your stay!<br />
    volumes:
     - mumble-data:/var/lib/mumble-server

volumes:
  mumble-data:
```

## Using ACME to Generate Certificates

The container can automatically generate and renew trusted certificates verified by LetsEncrypt using DNS verification. This allows you to generate certificates behind a firewall, but only works if you have a [supported DNS provider](https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md).

Here is an example Docker Compose file. Notice that there is an extra volume that must be persisted for the ACME cert data:

```yaml
version: '3'
services:
  murmur:
    image: kadimasolutions/murmur:latest
    environment:
      ACME_ENABLED: "true" # Default: false
      ACME_TEST_MODE: "true" # Default: false
      ACME_DOMAIN: mumble.mysite.com # Default: example.com
      ACME_KEYSTORE_PASSWORD: helloworld # Default: changeit
      # See https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md
      ACME_DOMAIN_PROVIDER: dns_aws # Default: dns_cf
      # Access keys specific to domain provider
      AWS_ACCESS_KEY_ID: supersecretkeyid
      AWS_SECRET_ACCESS_KEY: supersecretaccesskey
    ports:
     - 64738:64738
    volumes:
     - mumble-data:/var/lib/mumble-server
     - acme-data:/root/.acme.sh

volumes:
  mumble-data:
  acme-data:
```

> **Note:** The container will automatically renew the certificate before it expires. After the certificate is renewed the Mumble server will **restart automatically**. The server will be down for the short period of time that it takes Murmur to restart.
>
>The certificate renewal check is performed at 12:30am every day.
