FROM python:3.15-bookworm@sha256:b97b63f7b64698bebb0651b6a5842d33f4493a6902291d36acc5a768e383b950

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
