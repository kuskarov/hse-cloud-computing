#!/bin/sh

echo "Waiting for postgres..."
while ! nc -z "$SQL_HOST" "$SQL_PORT"; do
  sleep 0.1
done
echo "PostgreSQL started"

if [ "$CREATE_TABLE" = "True" ]; then
  echo "Creating the database tables..."
  python manage.py create_db
  echo "Tables created"
else
  echo "Skipping table creation"
fi

echo "Registering this backend in database..."
python manage.py register
echo "Registered"

if [ "$COMPOSE" != "True" ]; then
  echo "Running without docker-compose..."
  gunicorn --bind 0.0.0.0:5000 manage:app
else
  exec "$@"
fi
