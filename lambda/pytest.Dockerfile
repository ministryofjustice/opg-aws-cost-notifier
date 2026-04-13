FROM python:3-bookworm@sha256:4564a2be4617886b3a7ed704c91e31b95efd1f42d5941f5bb5e53efb151edaa3

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
