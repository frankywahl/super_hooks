COMMIT=$(shell git rev-parse HEAD)

GITHUB_TOKEN?=""
VERSION?=0.0.0
DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
SOURCE?="github.com/frankywahl/super_hooks"

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X ${SOURCE}/version.GitRevision=${COMMIT} -X ${SOURCE}/version.Version=${VERSION} -X ${SOURCE}/version.CreatedAt=${DATE}"

.PHONY: help
help: ## Show this help
	@grep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?\#\# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Install the binaries on the local machine
	go install ${LDFLAGS}

.PHONY: test
test: ## Run the test suite
	go test -v --race ./...

.PHONY: vet
vet: ## Make sure vet passes
	go vet ./...

.PHONY: fmt
fmt: ## Run the go-formatter
	test -z $$(gofmt -l .) # This will return non-0 if unsuccessful  run `go fmt ./...` to fix

.PHONY: release
release: ## Build a release locally. This will not be published
	git tag v${VERSION} || git tag --delete v${VERSION} && git tag v${VERSION}
	docker run --rm --privileged \
		-v $(shell pwd):/go/src/github.com/frankywahl/super_hooks \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /go/src/github.com/frankywahl/super_hooks \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-e SOURCE=${SOURCE} \
		goreleaser/goreleaser release --rm-dist --snapshot --skip-publish

.PHONY: docker
docker: ## Build a docker image
	docker build -t ghcr.io/frankywahl/super_hooks .

.PHONY: vulncheck
vulncheck: ## Run vulnerability scanner check
	go run golang.org/x/vuln/cmd/govulncheck ./...
