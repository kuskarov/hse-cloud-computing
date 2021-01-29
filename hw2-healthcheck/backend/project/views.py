from project import app, db
from project.util import utcnow
from project.models import ServiceStatus
from project.config import Config


@app.route('/healthcheck')
def healthcheck():
    try:
        statuses = ServiceStatus.query.all()
        now = utcnow()
        results = []
        for s in statuses:
            if (now - s.last_seen_ts).total_seconds() <= 2 * Config.HEARTBEAT_TIMEOUT:
                results.append(
                    {
                        "ip": s.ip,
                        "status": "AVAILABLE"
                    })
        return {"ip": Config.IP, "services": results}
    except:
        db.session.rollback()
        return {"error": "Database is unavailable"}
