FROM python:3-bookworm@sha256:1327ba953d9f7083ac4f7cbc813ddbd963a74b082bc35254535e6fcb65c9ce90

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
