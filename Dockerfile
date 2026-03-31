ARG HUGO_VERSION="0.157.0"
ARG TARGETARCH

FROM ghcr.io/gohugoio/hugo:v${HUGO_VERSION} AS hugo-build

WORKDIR /project
COPY . /project
RUN hugo --minify

FROM nginxinc/nginx-unprivileged:1.29-alpine-slim

COPY --from=hugo-build /project/public /usr/share/nginx/html

EXPOSE 8080/tcp