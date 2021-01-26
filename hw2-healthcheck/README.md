# HW 2: Healthcheck service

Configuration has nginx reverse proxy server, PostgreSQL database and 2 instances of backend healthcheck service written on Flask.

## Usage

1) for first usage: set `CREATE_TABLE=True` in `.env.backend` file, then `docker-compose up`.

2) otherwise keep `CREATE_TABLE=False` and run by `docker-compose up`.

3) you can drop database by `docker-compose down -v`. After that see 1).

## Testing

`curl localhost:1337/healthcheck`

## Links

1) [Using SQLAlchemy with Flask and PostgreSQL](https://stackabuse.com/using-sqlalchemy-with-flask-and-postgresql/)

2) [Dockerizing Flask with Postgres, Gunicorn, and Nginx](https://testdriven.io/blog/dockerizing-flask-with-postgres-gunicorn-and-nginx/)

3) [Using threading.Timer for periodically writing to database](https://github.com/parseendavid/template-flask-with-background-thread-writing-to-db)
