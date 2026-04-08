ARG HUGO_VERSION="0.157.0"
ARG TARGETARCH

FROM ghcr.io/gohugoio/hugo:v${HUGO_VERSION} AS hugo-build

WORKDIR /project
COPY . /project
RUN hugo --minify

FROM ghcr.io/static-web-server/static-web-server:2.42

COPY --from=hugo-build /project/public /public

EXPOSE 80/tcp