FROM python:3.10.8-slim-buster

RUN apt update && apt install curl make -y

ENV DOCKER_VERSION 20.10.20
RUN curl -fsSL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
  | tar -xzC /usr/local/bin --strip=1 docker/docker

RUN pip install bump

COPY python-example-app ./python-example-app

COPY integration-test ./integration-test

COPY Makefile dockerHubPassword .pypirc ./

ENTRYPOINT ["make"]