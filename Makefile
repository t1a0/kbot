APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=t1aa
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

linux:
	$(MAKE) build GOOS=linux GOARCH=amd64

mac:
	$(MAKE) build GOOS=darwin GOARCH=amd64

windows:
	$(MAKE) build GOOS=windows GOARCH=amd64

arm:
	$(MAKE) build GOOS=linux GOARCH=arm64

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/t1a0/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	@if docker images ${REGISTRY}/${APP}:${VERSION} -q | grep -q '.' ; then \
		docker rmi ${REGISTRY}/${APP}:${VERSION}; \
	fi
