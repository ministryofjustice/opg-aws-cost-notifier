FROM python:3-bookworm@sha256:5fa5eb41d78d004d4b6d315ab566856b5fd331655440ea1f2690d9caeecfe6a5

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
