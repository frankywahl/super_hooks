FROM golang:1.17-alpine as build-env
RUN apk update && apk add make git
WORKDIR $GOPATH/src/github.com/user/app
COPY go.sum .
COPY go.mod .
RUN go mod download
COPY . .
RUN make install

FROM alpine
WORKDIR /app
RUN apk update && apk add git
COPY --from=build-env /go/bin/super_hooks /usr/local/bin/.
ENTRYPOINT ["super_hooks"]
