import socket
from datetime import datetime


def get_ip():
    return socket.gethostbyname(socket.gethostname())


def utcnow():
    return datetime.utcnow()
