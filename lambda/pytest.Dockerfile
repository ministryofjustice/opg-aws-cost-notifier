FROM python:3.15-bookworm@sha256:6f060cab421d9509c6c6a6a7762c651baf03c3f1d0145befe16b688762b7fe81

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
