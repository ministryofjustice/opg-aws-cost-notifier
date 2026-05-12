FROM python:3-bookworm@sha256:338404de659047cab13f39fa284f8ca2383f9f15b5043300233e3c1b758545b7

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
