FROM golang:alpine

RUN apk add build-base curl git
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
ADD . $GOPATH/src/app
WORKDIR $GOPATH/src/app
RUN make install
RUN make dist

FROM alpine

RUN apk --update upgrade && \
    apk add curl ca-certificates openssh-client && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

COPY --from=0 /go/src/app/build/consul-envoy-linux-amd64 /consul-envoy

ENTRYPOINT ["/consul-envoy"]
