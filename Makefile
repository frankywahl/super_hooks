VERSION="0.0.1"
COMMIT=$(shell git rev-parse HEAD)

GITHUB_TOKEN?=""

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X github.com/frankywahl/super_hooks/version.GitRevision=${COMMIT} -X github.com/frankywahl/super_hooks/version.Version=${VERSION}"

# Build the project
all: clean test vet fmt

install:
	go install ${LDFLAGS}

test:
	go test -v --race ./...

vet:
	go vet ./...

fmt:
	test -z $$(gofmt -l .) # This will return non-0 if unsuccessful  run `go fmt ./...` to fix

release:
	docker run --rm --privileged \
		-v $(shell pwd):/go/src/github.com/frankywahl/super_hooks \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /go/src/github.com/frankywahl/super_hooks \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		goreleaser/goreleaser release --rm-dist

.PHONY: test vet fmt clean install


