ARG HUGO_VERSION="v0.157.0@sha256:7891d7636d357b582576ebb5cdfc990bf514827a6389aec624b12c2126d6127a"
ARG STATIC_WEB_SERVER_VERSION="2.42@sha256:2d67e47e22172235e339908777e692006ffdcf42dc4c531aff5d4337a7559a1e"
ARG TARGETARCH

FROM ghcr.io/gohugoio/hugo:${HUGO_VERSION} AS hugo-build

WORKDIR /project
COPY . /project
RUN hugo --minify

FROM ghcr.io/static-web-server/static-web-server:${STATIC_WEB_SERVER_VERSION}

COPY --from=hugo-build /project/public /public

ENV SERVER_SECURITY_HEADERS=true
ENV SERVER_METRICS=true
ENV SERVER_HEALTH=true

EXPOSE 80/tcp