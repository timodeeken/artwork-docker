#/bin/bash

docker-compose exec --user=0 artwork_app php artisan key:generate
docker-compose exec artwork_app php artisan optimize
docker-compose exec artwork_app php artisan migrate:fresh --force --seed