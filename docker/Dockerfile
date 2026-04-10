ARG HUGO_VERSION="v0.159.1@sha256:3647208bc2456d9d85efcf0906e21882cacd4a0739d4fccc86bdfc81a9573546"
ARG STATIC_WEB_SERVER_VERSION="2.42@sha256:2d67e47e22172235e339908777e692006ffdcf42dc4c531aff5d4337a7559a1e"
ARG TARGETARCH

FROM ghcr.io/gohugoio/hugo:${HUGO_VERSION} AS hugo-build

WORKDIR /project
COPY . /project
RUN hugo --minify

FROM ghcr.io/static-web-server/static-web-server:${STATIC_WEB_SERVER_VERSION}

COPY --chown=1000:1000 --from=hugo-build /project/public /public
COPY --chown=1000:1000 static-web-server-config.toml /sws.toml

USER 1000:1000

EXPOSE 80/tcp