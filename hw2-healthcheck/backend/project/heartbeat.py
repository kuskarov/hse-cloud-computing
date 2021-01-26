from threading import Timer
from project.models import ServiceStatus
from project.util import get_ip, utcnow
from project.config import Config


def update_db(db):
    try:
        ip = get_ip()
        entry = ServiceStatus.query.get(ip)
        if entry is None:
            db.session.add(ServiceStatus(ip, utcnow()))
        else:
            entry.last_seen_ts = utcnow()
        db.session.commit()
    except Exception as e:
        print(f"There was an Error: {e}")


def start_thread(db):
    class RepeatTimer(Timer):
        def run(self):
            while not self.finished.wait(self.interval):
                self.function(*self.args, **self.kwargs)

    # Call the write to db function every HEARTBEAT_TIMEOUT seconds
    thread = RepeatTimer(Config.HEARTBEAT_TIMEOUT, update_db, [db])
    # Make thread run in the background
    thread.daemon = True
    # Start thread
    thread.start()
