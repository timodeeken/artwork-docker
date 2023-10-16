# Installation

## Docker

Install the docker-daemon from https://docs.docker.com/engine/install/ 

After installation create the network by running `docker network create artwork`

### Config

- Copy the ``.env.example`` file into a new file `.env` via the command `cp .env.example .env`
- Adjust the values in the new ``.env`` file to your settings. The default should already be ready to function

### SSL

- Edit the ``init-letsencrypt.sh`` file. Replace `domains=(your.domain)` with your domain name and your domain name containing www. 
For example: ``domains=(artwork.de www.artwork.de)``
- Run ``chmod +x init-letsencrypt.sh && sh init-letsencrypt.sh``
- Open the ``nginx.vhost.conf`` under `docker/nginx/nginx.vhost.conf` and uncomment the ssl section. 
Don't forget to update the path for the certificate with your domain

### Start
Run ``docker compose up -d --build``

### Initialization

Run ``chmod +x setup.sh && ./setup.sh`` this should set the crypt key and seeds the database