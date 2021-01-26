from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config.from_object("project.config.Config")

db = SQLAlchemy(app)

from project.heartbeat import start_thread

start_thread(db)

from project.views import healthcheck
