from flask.cli import FlaskGroup

from project import app, db, ServiceStatus, ServiceStatusEnum, get_ip

cli = FlaskGroup(app)


@cli.command("create_db")
def create_db():
    db.drop_all()
    db.create_all()
    db.session.commit()


@cli.command("register")
def register():
    ip = get_ip()
    if ServiceStatus.query.get(ip) is None:
        db.session.add(ServiceStatus(ip=ip, status=ServiceStatusEnum.AVAILABLE))
        db.session.commit()


if __name__ == "__main__":
    cli()
