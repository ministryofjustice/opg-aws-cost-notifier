FROM python:3-bookworm@sha256:7e4daf6d16a60d46eba15891f2ae7528e0cfb7cf9c875f51813d77224b5734dc

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
