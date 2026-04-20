# syntax=docker/dockerfile:1.2

FROM alpine AS builder

ARG VERSION=1.0

RUN apk add --no-cache git openssh-client

RUN mkdir -p -m 0700 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh \
    git clone git@github.com:Chrabaszcz03/pawcho6.git /repo

RUN echo "<!DOCTYPE html><html><head><title>Lab6</title><meta charset='utf-8'></head><body>" > /index.html && \
    echo "<h1>Kontener Docker - Lab 6</h1>" >> /index.html && \
    echo "<p><strong>Adres IP:</strong> $(hostname -i)</p>" >> /index.html && \
    echo "<p><strong>Hostname:</strong> $(hostname)</p>" >> /index.html && \
    echo "<p><strong>Wersja:</strong> ${VERSION}</p>" >> /index.html && \
    echo "</body></html>" >> /index.html

FROM nginx:alpine

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

COPY --from=builder /index.html /usr/share/nginx/html/index.html

LABEL org.opencontainers.image.source="https://github.com/Chrabaszcz03/pawcho6"
LABEL org.opencontainers.image.description="Lab 6 - PAwChO"
LABEL org.opencontainers.image.authors="TWOJE_IMIE"

HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80