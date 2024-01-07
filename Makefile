VERSION:

format:
	gofmt -s -w ./

build:
	go build -v -o kbot -ldflags "-X="github.com/t1a0/kbot/cmd.appVersion=v1.0.5