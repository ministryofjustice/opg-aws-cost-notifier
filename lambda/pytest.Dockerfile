FROM python:3-bookworm@sha256:d1552003e0eb6e4a2c57fcc17c1b1f14fca6b00b1b709bb0e4eb82f21bce5c8c

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
