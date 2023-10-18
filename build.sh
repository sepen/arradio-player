#!/bin/bash -e

# Requirements
case $(uname -s) in

    Linux)
        export GOOS=linux
        export GOARCH=amd64 # TODO: 386, arm, arm64
        # Install Golang 1.21.x (Debian uses a deprecated 1.15.x)
        if [ ! -d $HOME/opt/go-1.21.3 ]; then
            mkdir -p $HOME/opt && cd $HOME/opt
            wget -P $HOME/opt https://go.dev/dl/go1.21.3.linux-$GOARCH.tar.gz
            tar xf go1.21.3.linux-$GOARCH.tar.gz
            mv go go-1.21.3 && ln -s go-1.21.3 go
        fi
        export PATH="$HOME/opt/go/bin:$PATH"
        export GOPATH="$HOME/.go"
        # Cgo is required
        export CGO_ENABLED=1
        # ALSA is required
        if ! dpkg -s libasound2-dev >/dev/null 2>&1; then
            apt-get install -y libasound2-dev
        fi
        ;;

    Darwin)
        export GOOS=darwin
        export GOARCH=amd64 # TODO: arm64
        # Cgo is not required
        export CGO_ENABLED=0
        ;;
esac


# Cleanup
go clean -modcache

# Init
[ ! -f go.mod ] && go mod init arradio-player

# Deps
go mod tidy

# Debug
go run arradio-player || echo "Exit $?"

# Build executable
go build
