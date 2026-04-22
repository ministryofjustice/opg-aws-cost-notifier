FROM python:3-bookworm@sha256:2faad0f3fc03ee3aaa1f9120713533c839ee21d3fa99ca940a3dd41dcc602509

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
