FROM golang:stretch as builder

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GOOS linux
ENV GO111MODULE on

WORKDIR $GOPATH


# Uncomment during development
# COPY . github.com/jonas747/yagpdb

RUN go get -v github.com/jonas747/yagpdb/cmd/yagpdb

FROM alpine:latest

ENV GAUTH false

WORKDIR /app
VOLUME /app/soundboard \
  /app/cert
EXPOSE 80 443

# We need the X.509 certificates for client TLS to work.
RUN apk --no-cache add ca-certificates

# Add ffmpeg for soundboard support
RUN apk --no-cache add ffmpeg

# Handle templates for plugins automatically
COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/*/assets/*.html templates/plugins/

COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/cmd/yagpdb/templates templates/
COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/cmd/yagpdb/posts posts/
COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/cmd/yagpdb/static static/

COPY --from=builder /go/bin/yagpdb .

COPY ./start.sh /app/start.sh

ENTRYPOINT ["/app/start.sh"]
CMD ["-all", "-exthttps=true", "-https=false"]
