FROM python:3-bookworm@sha256:88fc4c2b51057109ed52b318baac165da9f3672a39c9f17b56ebf034ce2fa4b7

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
