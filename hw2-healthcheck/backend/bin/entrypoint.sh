#!/bin/sh

IP=$(ip addr | grep -m 1 global | cut -d ' ' -f 6 | cut -d '/' -f 1)

echo "My IP is $IP"

echo "Waiting for postgres..."
while ! nc -z "$SQL_HOST" "$SQL_PORT"; do
  sleep 0.1
done
echo "PostgreSQL started"

if [ "$CREATE_TABLE" = true ]; then
  echo "Creating the database tables..."
  python manage.py create_db
  echo "Tables created"
else
  echo "Skipping table creation"
fi

echo "Registering this backend in database..."
python manage.py register
echo "Registered"

if [ "$COMPOSE" != true ]; then
  echo "Running without docker-compose..."
  gunicorn --bind 0.0.0.0:80 manage:app
else
  exec "$@"
fi
