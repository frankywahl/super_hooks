FROM alpine

ARG BUILD_VERSION
ARG REVISION
ARG BUILD_DATE
ARG SOURCE

LABEL org.opencontainers.image.revision=$REVISION \
  org.opencontainers.image.source=$SOURCE \
  org.opencontainers.image.version=$BUILD_VERSION \
  org.opencontainers.image.created=$BUILD_DATE

COPY super_hooks /usr/local/bin/.

RUN apk update && apk add --no-cache \
  ca-certificates \
  openssl

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

ENTRYPOINT ["super_hooks"]
