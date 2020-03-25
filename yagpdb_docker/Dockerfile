FROM golang:stretch as builder

ENV CGO_ENABLED 0
ENV GOOS linux
ENV GO111MODULE on

# Uncomment during development
COPY . /appbuild/yagpdb

WORKDIR /appbuild/yagpdb/cmd/yagpdb

RUN ./build.sh

FROM alpine:latest

WORKDIR /app
VOLUME /app/soundboard \
  /app/cert
EXPOSE 80 443

# We need the X.509 certificates for client TLS to work.
RUN apk --no-cache add ca-certificates

# Add ffmpeg for soundboard support
RUN apk --no-cache add ffmpeg

# Handle templates for plugins automatically
COPY --from=builder /appbuild/yagpdb/*/assets/*.html templates/plugins/

COPY --from=builder /appbuild/yagpdb/cmd/yagpdb/templates templates/
COPY --from=builder /appbuild/yagpdb/cmd/yagpdb/posts posts/
COPY --from=builder /appbuild/yagpdb/cmd/yagpdb/static static/

COPY --from=builder /appbuild/yagpdb/cmd/yagpdb .

COPY --from=builder /appbuild/yagpdb/yagpdb_docker/start.sh .

# `exec` allows us to receive shutdown signals.
ENTRYPOINT ["/app/start.sh"]
CMD ["/app/yagpdb", "-all", "-exthttps=true", "-https=false"]
