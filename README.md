# Wordplate with Docker

Go to `https://wordplate.github.io/salt/` to edit env var.

sudo nano /etc/hosts
127.0.0.1       caddy

Run project:
```
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
./runc composer install
```
Go on http://caddy/

if you want to edit
- sudo chown -R alexandre:www-data *
then (to give wordpress the right to edit file):
- ./runc chown -R www-data:www-data *
