from flask.cli import FlaskGroup
from project import app, db
from project.heartbeat import update_db

cli = FlaskGroup(app)


@cli.command("create_db")
def create_db():
    db.drop_all()
    db.create_all()
    db.session.commit()


@cli.command("register")
def register():
    update_db(db)


if __name__ == "__main__":
    cli()
