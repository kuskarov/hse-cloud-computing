# HW 2: Healthcheck service

Configuration has nginx reverse proxy server, PostgreSQL database and 2 instances of backend healthcheck service written
on Flask.

## Local deploy

1) for first usage: set `CREATE_TABLE=True` in `.env.backend` file, then `docker-compose up`.

2) otherwise keep `CREATE_TABLE=False` and run by `docker-compose up`.

3) you can drop database by `docker-compose down -v`. After that see 1).

## Local testing

`curl localhost/healthcheck`

## Cloud

Export env variables `FOLDER_NAME`, `YANDEX_OAUTH`, `CLOUD_ID`, `SERVICE_ACCOUNT_ID` and `REGISTRY_NAME`,
then `./deploy.sh`.

`IP` of nginx load balancer will be in output. Test by `curl IP/healthcheck`.

To destroy configuration, do `cd terraform && terraform destroy`.

## Links

1) [Using SQLAlchemy with Flask and PostgreSQL](https://stackabuse.com/using-sqlalchemy-with-flask-and-postgresql/)

2) [Dockerizing Flask with Postgres, Gunicorn, and Nginx](https://testdriven.io/blog/dockerizing-flask-with-postgres-gunicorn-and-nginx/)

3) [Using threading.Timer for periodically writing to database](https://github.com/parseendavid/template-flask-with-background-thread-writing-to-db)

4) [Example of terraform config for Yandex.Cloud](https://jnotes.ru/yandex-cloud-experience.html)
