FROM python:3-bookworm@sha256:f13eccd51dfc84c6c161d0fe8654fe320fe38a387e25e45a83c6e503c1bcd7be

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
