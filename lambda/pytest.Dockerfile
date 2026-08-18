FROM python:3-bookworm@sha256:8771427e2ac3e39208c1632f17e8b09e464333d262844a03705cc5e0023c16e2

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
