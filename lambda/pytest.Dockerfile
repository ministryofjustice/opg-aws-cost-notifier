FROM python:3-bookworm@sha256:f357fca37376cc10aba3bb909d13bba0108a39670d7b9bc8b4039ac94674e874

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
