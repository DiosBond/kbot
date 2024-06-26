APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := diosbond
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
#TARGETARCH=amd64 #amd64 arm64
CFLAGS=-m64
TARGETARCH=amd64 #x86_64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
#	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/diosbond/kbot/cmd.appVersion=${VERSION}
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/diosbond/kbot/cmd.appVersion=${VERSION}

image:
#docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH}
#--platform=linux/amd64,linux/arm64
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --platform=linux/amd64

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
