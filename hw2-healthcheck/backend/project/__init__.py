from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import socket
import enum

app = Flask(__name__)
app.config.from_object("project.config.Config")

db = SQLAlchemy(app)


def get_ip():
    return socket.gethostbyname(socket.gethostname())


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


@app.route('/healthcheck')
def healthcheck():
    try:
        statuses = ServiceStatus.query.all()
        results = [
            {
                "ip": s.ip,
                "status": "AVAILABLE"
            } for s in statuses]

        return {"ip": get_ip(), "services": results}
    except:
        return {"error": "Database is unavailable"}


if __name__ == "__main__":
    app.run(debug=True)
