FROM python:3-bookworm@sha256:ecac9e212daacda8a702eae372fceebc0ee36f5805abe087880367e8d061fa5b

RUN mkdir /app

WORKDIR /app
COPY requirements.txt requirements.txt
COPY requirements.dev.txt requirements.dev.txt

RUN pip install -Ur requirements.dev.txt
