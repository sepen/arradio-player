#!/bin/bash -e

# GOARCH
case $(uname -m) in
  *86) export GOARCH="386" ;;
  x86_64|amd64) export GOARCH="amd64" ;;
  arm) export GOARCH="arm" ;;
  arm64) export GOARCH="arm64" ;;
esac

# GOOS
case $(uname -s) in
  Linux) export GOOS="linux" CGO_ENABLED=1 ;;
  Darwin) export GOOS="darwin" CGO_ENABLED=0 ;;
esac

readonly DEBUG=${DEBUG:-0}
readonly ARRADIO_PLAYER_VERSION="0.0.1"
readonly ARRADIO_PLAYER_RELEASE="arradio-player-$ARRADIO_PLAYER_VERSION.$GOOS-$GOARCH"
readonly GOLANG_VERSION="1.22.2"
readonly GOLANG_URL="https://go.dev/dl/go$GOLANG_VERSION.$GOOS-$GOARCH.tar.gz"

# Install Golang
if [ ! -d $HOME/opt/go ]; then
  mkdir -p $HOME/opt
  cd $HOME/opt
  echo "==> Checking for $GOLANG_URL"
  if ! curl -sSL --head --write-out '%{http_code}' $GOLANG_URL | tail -1 | grep '200' >/dev/null 2>&1; then
    echo "ERROR: $GOLANG_URL doesn't exits"
    exit 1
  fi
  echo "==> Downloading $GOLANG_URL"
  curl -SL -O $GOLANG_URL
  echo "==> Installing go$GOLANG_VERSION.$GOOS-$GOARCH"
  tar xf go$GOLANG_VERSION.$GOOS-$GOARCH.tar.gz
  cd -
fi
export PATH="$HOME/opt/go/bin:$PATH"
export GOPATH="$HOME/.go"

# Check for library dependencies
case $GOOS in
  Linux)
    # Check for Linux distributions
    if type -P dpkg >/dev/null 2>&1; then
      # Debian based
      if type -P apt-get >/dev/null 2>&1; then 
        if ! dpkg -s libasound2-dev >/dev/null 2>&1; then
          echo "** ALSA development libraries are required **"
          echo "Please run \`apt-get install -y libasound2-dev\`"
          exit 1
        fi
      fi
    fi
    # TODO: add more distros
    ;;
esac


# Cleanup
echo "==> Cleaning up module cache"
go clean -modcache

# Init
echo "==> Initializing module in current directory"
[ ! -f go.mod ] && go mod init arradio-player

# Deps
echo "==> Building module dependencies"
go mod tidy
echo "==> Verifying module dependencies"
go mod verify
echo "==> Showing module requirement graph"
go mod graph

# Debug
if [ $DEBUG -eq 1 ]; then
    echo "==> Running debug"
    go run arradio-player http://148.251.92.113:8524/stream || echo "Exit $?"
fi

# Build executable
echo "==> Building release"
# -s Will turn off the symbol table, so you won’t be able to use commands like `go tool nm`.
# -w Turns off the ‘DWARF’ debugging information, so you won’t be able to set breakpoints or get
# specific information in stacktraces. Likewise, certain profile use cases won’t work, like `pprof`.
rm -f $ARRADIO_PLAYER_RELEASE
if [ $DEBUG -eq 1 ]; then
  go build -o $ARRADIO_PLAYER_RELEASE
else
  go build -ldflags="-s -w" -o $ARRADIO_PLAYER_RELEASE
fi

echo "$ARRADIO_PLAYER_RELEASE"

# End of file
