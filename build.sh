#!/bin/bash -e

DEBUG=${DEBUG:-0}
RELEASE=${RELEASE:-0.0.1}

# GOOS
case $(uname -s) in
  Linux)
    export GOOS="linux"
    # Cgo is required
    export CGO_ENABLED=1
    # ALSA library is required
    # TODO: support non-debian based distros
    if ! dpkg -s libasound2-dev >/dev/null 2>&1; then
      sudo apt-get install -y libasound2-dev
    fi
    ;;
  Darwin)
    export GOOS="darwin"
    # Cgo is not required
    export CGO_ENABLED=0
    ;;
esac

# GOARCH
# TODO: arm, arm64
case $(uname -m) in
  *86)
    export GOARCH="386"
    ;;
  x86_64)
    export GOARCH="amd64"
    ;;
esac

# Install Go 1.21.x
if [ ! -d $HOME/opt/go ]; then
  mkdir -p $HOME/opt
  cd $HOME/opt
  wget -O https://go.dev/dl/go1.21.3.$GOOS-$GOARCH.tar.gz
  tar xf go1.21.3.$GOOS-$GOARCH.tar.gz
  mv go
  cd -
fi
export PATH="$HOME/opt/go/bin:$PATH"
export GOPATH="$HOME/.go"

# Cleanup
go clean -modcache

# Init
[ ! -f go.mod ] && go mod init arradio-player

# Deps
go mod tidy

# Debug
if [ $DEBUG -eq 1 ]; then
    go run arradio-player http://148.251.92.113:8524/stream || echo "Exit $?"
fi

# Build executable
# -s Will turn off the symbol table, so you won’t be able to use commands like `go tool nm`.
# -w Turns off the ‘DWARF’ debugging information, so you won’t be able to set breakpoints or get
# specific information in stacktraces. Likewise, certain profile use cases won’t work, like `pprof`.
if [ $DEBUG -eq 1 ]; then
  go build -o arradio-player-$RELEASE-debug.$GOOS-$GOARCH
else
  go build -ldflags="-s -w" -o arradio-player-$RELEASE.$GOOS-$GOARCH
fi

# End of file
