from flask.cli import FlaskGroup
from datetime import datetime
from project import app, db, ServiceStatus, get_ip

cli = FlaskGroup(app)


@cli.command("create_db")
def create_db():
    db.drop_all()
    db.create_all()
    db.session.commit()


@cli.command("register")
def register():
    ip = get_ip()
    entry = ServiceStatus.query.get(ip)
    if entry is None:
        db.session.add(ServiceStatus())
    else:
        entry.last_seen_ts = datetime.utcnow()
    db.session.commit()


if __name__ == "__main__":
    cli()
