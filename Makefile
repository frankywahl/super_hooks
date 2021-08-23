COMMIT=$(shell git rev-parse HEAD)

GITHUB_TOKEN?=""
VERSION?=0.0.0
DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
SOURCE?="github.com/frankywahl/super_hooks"

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X ${SOURCE}/version.GitRevision=${COMMIT} -X ${SOURCE}/version.Version=${VERSION} -X ${SOURCE}/version.CreatedAt=${DATE}"

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
	git tag v${VERSION} || git tag -d v${VERSION} && git tag v${VERSION}
	docker run --rm --privileged \
		-v $(shell pwd):/go/src/github.com/frankywahl/super_hooks \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /go/src/github.com/frankywahl/super_hooks \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-e SOURCE=${SOURCE} \
		goreleaser/goreleaser release --rm-dist --snapshot --skip-publish

.PHONY: test vet fmt clean install

docker:
	docker build -t docker.pkg.github.com/frankywahl/super_hooks/cli .
	docker build -t ghcr.io/frankywahl/super_hooks .
