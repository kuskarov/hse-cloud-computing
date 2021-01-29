#!/usr/bin/env bash

set -e

echo "Testing connection from backends to postgres..."
docker-compose exec backend1 bash -c 'nc -zv postgresql 5432'
docker-compose exec backend2 bash -c 'nc -zv postgresql 5432'

echo ""
echo "Testing connection from nginx to backends..."
docker-compose exec nginx sh -c 'nc -zv backend1 80'
docker-compose exec nginx sh -c 'nc -zv backend2 80'

echo ""
echo "IP should be different:"
curl localhost/healthcheck
curl localhost/healthcheck

echo ""
echo "Stopping postgresql..."
docker-compose stop postgresql

echo ""
echo "Database should be unavailable"
curl localhost/healthcheck
