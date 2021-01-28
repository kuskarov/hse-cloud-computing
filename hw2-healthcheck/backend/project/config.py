import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    IP = os.getenv("IP", "")
    SQLALCHEMY_DATABASE_URI = os.getenv("DATABASE_URL", "")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JSONIFY_PRETTYPRINT_REGULAR = True
    HEARTBEAT_TIMEOUT = 1
