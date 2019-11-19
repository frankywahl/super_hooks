BINARY = super_hooks
VET_REPORT = vet.report
TEST_REPORT = tests.xml
GOARCH = amd64

VERSION="0.0.1"
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

# Symlink into GOPATH
GITHUB_USERNAME=frankywahl
BUILD_DIR=${GOPATH}/src/github.com/${GITHUB_USERNAME}/${BINARY}
GITHUB_TOKEN?= "TBD"

# Setup the -ldflags option for go build here, interpolate the variable values
LDFLAGS = -ldflags "-X github.com/frankywahl/super_hooks/version.GitRevision=${COMMIT} -X github.com/frankywahl/super_hooks/version.Version=${VERSION}"

# Build the project
all: clean test vet linux darwin windows

install:
	cd ${BUILD_DIR}; \
	go install ${LDFLAGS}; \
	cd - >/dev/null

test:
	cd ${BUILD_DIR}; \
	go test -v ./... 2>&1 | tee ${TEST_REPORT} ; \
	cd - >/dev/null

vet:
	-cd ${BUILD_DIR}; \
	go vet ./... > ${VET_REPORT} 2>&1 ; \
	cd - >/dev/null

fmt:
	cd ${BUILD_DIR}; \
	go fmt $$(go list ./... | grep -v /vendor/) ; \
	cd - >/dev/null

clean:
	-rm -f ${TEST_REPORT}
	-rm -f ${VET_REPORT}
	-rm -f ${BINARY}
	-rm -f ${BINARY}-*

release:
	docker run --rm --privileged \
		-v $(shell pwd):/go/src/github.com/frankywahl/super_hooks \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /go/src/github.com/frankywahl/super_hooks \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		goreleaser/goreleaser release \
			--rm-dist

.PHONY: linux darwin windows test vet fmt clean install


