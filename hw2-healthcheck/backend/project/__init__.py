from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import socket
from datetime import datetime
from sqlalchemy.exc import OperationalError

app = Flask(__name__)
app.config.from_object("project.config.Config")

db = SQLAlchemy(app)


def get_ip():
    return socket.gethostbyname(socket.gethostname())


class ServiceStatus(db.Model):
    __tablename__ = "service_status"

    ip = db.Column(db.String(), primary_key=True)
    last_seen_ts = db.Column(db.DateTime())

    def __init__(self):
        self.ip = get_ip()
        self.last_seen_ts = datetime.utcnow()


@app.route('/healthcheck')
def healthcheck():
    try:
        statuses = ServiceStatus.query.all()
        now = datetime.utcnow()
        results = [
            {
                "ip": s.ip,
                "status": "AVAILABLE" if (now - s.last_seen_ts).total_seconds() < 5 else "UNAVAILABLE"
            } for s in statuses]

        return {"ip": get_ip(), "services": results}
    except OperationalError:
        return {"error": "Database is unavailable"}


if __name__ == "__main__":
    app.run(debug=True)
