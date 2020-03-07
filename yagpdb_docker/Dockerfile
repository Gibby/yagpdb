FROM golang:stretch as builder

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GOOS linux
ENV GO111MODULE on
ENV VERSION v1.23.0

WORKDIR $GOPATH

RUN go get -v github.com/jonas747/yagpdb/cmd/yagpdb@"$VERSION"

RUN git clone https://github.com/jonas747/yagpdb.git && \
    cd yagpdb && \
    git checkout $VERSION && \
    cp -r /go/yagpdb/cmd/yagpdb/static/vendor /go/pkg/mod/github.com/jonas747/yagpdb*/cmd/yagpdb/static/


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
COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/*/assets/*.html templates/plugins/

COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/cmd/yagpdb/templates templates/
COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/cmd/yagpdb/posts posts/
COPY --from=builder /go/pkg/mod/github.com/jonas747/yagpdb*/cmd/yagpdb/static static/

COPY --from=builder /go/bin/yagpdb .

COPY ./start.sh /app/start.sh

ENV GAUTH false

ENTRYPOINT ["/app/start.sh"]
CMD ["/app/yagpdb", "-all", "-exthttps=true", "-https=false"]
