FROM alpine
ARG TARGETPLATFORM

COPY $TARGETPLATFORM/super_hooks /usr/bin

RUN apk update && apk add --no-cache \
  ca-certificates \
  openssl

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

ENTRYPOINT ["super_hooks"]
