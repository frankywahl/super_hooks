COMMIT=$(shell git rev-parse HEAD)

GITHUB_TOKEN?=""
VERSION?=0.0.0
DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
SOURCE?="github.com/frankywahl/super_hooks"

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X ${SOURCE}/version.GitRevision=${COMMIT} -X ${SOURCE}/version.Version=${VERSION} -X ${SOURCE}/version.CreatedAt=${DATE}"

.PHONY: install
install:
	go install ${LDFLAGS}

.PHONY: test
test:
	go test -v --race ./...

.PHONY: vet
vet:
	go vet ./...

.PHONY: fmt
fmt:
	test -z $$(gofmt -l .) # This will return non-0 if unsuccessful  run `go fmt ./...` to fix

.PHONY: release
release:
	git tag v${VERSION} || git tag -d v${VERSION} && git tag v${VERSION}
	docker run --rm --privileged \
		-v $(shell pwd):/go/src/github.com/frankywahl/super_hooks \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /go/src/github.com/frankywahl/super_hooks \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-e SOURCE=${SOURCE} \
		goreleaser/goreleaser release --rm-dist --snapshot --skip-publish

.PHONY: docker
docker:
	docker build -t ghcr.io/frankywahl/super_hooks .
