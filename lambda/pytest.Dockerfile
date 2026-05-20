FROM python:3-bookworm@sha256:3b54e7d667afe30e0561a8e4e0b2d53c0cf8db446ace8aec2c92e15648f47767

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
