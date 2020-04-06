FROM golang:1.15-alpine as build-env
RUN apk add --update make && apk add --update git
WORKDIR $GOPATH/src/github.com/user/app
COPY go.sum .
COPY go.mod .
RUN go mod download
COPY . .
RUN make install

FROM alpine
WORKDIR /app
RUN apk add --update git
COPY --from=build-env /go/bin/super_hooks /usr/local/bin/.
CMD ["super_hooks"]
