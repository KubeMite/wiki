FROM alpine:3 AS build

ARG HUGO_VERSION="0.157.0"
ARG TARGETARCH

# Install Hugo
# hadolint ignore=DL3059
RUN apk add --no-cache curl=~8 libc6-compat=~1 libstdc++=~15
# hadolint ignore=DL3059
RUN /bin/ash -eo pipefail -c "if [ "$TARGETARCH" = "arm64" ]; then ARCH="arm64"; else ARCH="amd64"; fi && \
    curl -fsSL -O https://github.com/gohugoio/hugo/releases/download/v"$HUGO_VERSION"/hugo_extended_"$HUGO_VERSION"_linux-"$ARCH".tar.gz && \
    curl -fsSL -O https://github.com/gohugoio/hugo/releases/download/v"$HUGO_VERSION"/hugo_"$HUGO_VERSION"_checksums.txt && \
    grep hugo_extended_"$HUGO_VERSION"_linux-"$ARCH".tar.gz hugo_"$HUGO_VERSION"_checksums.txt | sha256sum -c || { echo "Sha256sum of hugo binary is incorrect!"; exit 1; } && \
    tar xzf hugo_extended_"$HUGO_VERSION"_linux-"$ARCH".tar.gz -C /usr/local/bin && \
    rm hugo*"

COPY . /app
WORKDIR /app
RUN hugo

FROM nginxinc/nginx-unprivileged:1.29-alpine-slim

COPY --from=build /app/public /usr/share/nginx/html

EXPOSE 8080/tcp