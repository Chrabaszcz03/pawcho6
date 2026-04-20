
FROM scratch AS lab5

ADD /assets/alpine-minirootfs-3.23.3-x86_64.tar /

ARG VERSION=1.0

WORKDIR /assets

RUN echo "<!DOCTYPE html><html><head><title>Zadanie Lab 5</title><meta charset='utf-8'></head><body>" > index.html && \
    echo "<h1>Kontener:</h1>" >> index.html && \
    echo "<p><strong>Adres IP serwera:</strong> $(hostname -i)</p>" >> index.html && \
    echo "<p><strong>Nazwa serwera (hostname):</strong> $(hostname)</p>" >> index.html && \
    echo "<p><strong>Wersja aplikacji:</strong> ${VERSION}</p>" >> index.html && \
    echo "</body></html>" >> index.html


FROM nginx:alpine

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

COPY --from=lab5 /assets/index.html /usr/share/nginx/html/index.html

HEALTHCHECK --interval=10s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80