from project import db


class ServiceStatus(db.Model):
    __tablename__ = "service_status"

    ip = db.Column(db.String(), primary_key=True)
    last_seen_ts = db.Column(db.DateTime())

    def __init__(self, ip, ts):
        self.ip = ip
        self.last_seen_ts = ts
