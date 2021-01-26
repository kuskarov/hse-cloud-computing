from flask import Flask
from flask_migrate import Migrate
from flask_sqlalchemy import SQLAlchemy
import socket
import enum

app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql://postgres:postgres@localhost:5432/test_flask"
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
db = SQLAlchemy(app)
migrate = Migrate(app, db)
local_ip = socket.gethostbyname(socket.gethostname())


class ServiceStatusEnum(enum.Enum):
    AVAILABLE = 1
    NOT_AVAILABLE = 2


class ServiceStatus(db.Model):
    __tablename__ = "service_status"

    ip = db.Column(db.String(), primary_key=True)
    status = db.Column(db.Enum(ServiceStatusEnum))

    def __init__(self, ip, status):
        self.ip = ip
        self.status = status


def register(ip):
    if ServiceStatus.query.get(ip) is None:
        db.session.add(ServiceStatus(ip=ip, status=ServiceStatusEnum.AVAILABLE))
        db.session.commit()
        print("Committed!")
    else:
        print("Already exists.")


register(local_ip)


@app.route('/healthcheck')
def healthcheck():
    try:
        statuses = ServiceStatus.query.all()
        results = [
            {
                "ip": s.ip,
                "status": "AVAILABLE"
            } for s in statuses]

        return {"ip": local_ip, "services": results}
    except:
        return {"error": "Database is unavailable"}


if __name__ == "__main__":
    app.run(debug=True)
