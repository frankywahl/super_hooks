COMMIT=$(shell git rev-parse HEAD)

GITHUB_TOKEN?=""
VERSION?="tip"
DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X github.com/frankywahl/super_hooks/version.GitRevision=${COMMIT} -X github.com/frankywahl/super_hooks/version.Version=${VERSION} -X github.com/frankywahl/super_hooks/version.CreatedAt=${DATE}"

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
	git tag v${VERSION}
	docker run --rm --privileged \
		-v $(shell pwd):/go/src/github.com/frankywahl/super_hooks \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /go/src/github.com/frankywahl/super_hooks \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		goreleaser/goreleaser release --rm-dist

.PHONY: test vet fmt clean install

docker:
	docker build -t docker.pkg.github.com/frankywahl/super_hooks/cli .
	docker build -t ghcr.io/frankywahl/super_hooks .
