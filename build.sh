#!/bin/bash -e

set_goos() {
  case $(uname -s) in
    Linux) GOOS="linux" ;;
    Darwin) GOOS="darwin" ;;
  esac
  export GOOS
}

set_goarch() {
  case $(uname -m) in
    *86) GOARCH="386" ;;
    x86_64|amd64) GOARCH="amd64" ;;
    arm|armv7*) GOARCH="arm" ;;
    arm64|aarch64) GOARCH="arm64" ;;
  esac
  export GOARCH
}

set_cgo() {
  case $GOOS in
    linux) CGO_ENABLED=1 ;;
    *) CGO_ENABLED=0 ;;
  esac
  export CGO_ENABLED
}

install_go() {
  local go_version="1.22.2"
  local go_os="$GOOS"
  local go_arch="$GOARCH"
  case $GOARCH in
    # last release supported
    386) go_version="1.21.9" ;;
    # arch name used in golang releases
    arm) go_arch="armv6l" ;;
  esac
  local go_filename="go${go_version}.${go_os}-${go_arch}.tar.gz"
  local go_url="https://go.dev/dl/${go_filename}"
  echo "==> Checking for ${go_url}"
  if ! curl -sSL --head --write-out '%{http_code}' ${go_url} | tail -1 | grep '200' >/dev/null 2>&1; then
    echo "ERROR: ${go_url} doesn't exits"
    exit 1
  fi
  echo "==> Downloading ${go_url}"
  curl -SL -O ${go_url}
  echo "==> Installing ${go_filename}"
  tar xf ${go_filename}
}

check_build_dependencies() {
  case $GOOS in
    linux)
      # Debian / Ubuntu
      if type -P dpkg >/dev/null 2>&1; then
        if type -P apt-get >/dev/null 2>&1; then
          if ! dpkg -s gcc >/dev/null 2>&1; then
            echo "** GCC compiler is required **"
            echo "Please run \`apt-get install -y gcc\`"
          fi
          if ! dpkg -s pkgconf >/dev/null 2>&1; then
            echo "** pkgconf is required for detecting libraries **"
            echo "Please run \`apt-get install -y pkgconf\`"
          fi
          if ! dpkg -s libasound2-dev >/dev/null 2>&1; then
            echo "** ALSA development libraries are required **"
            echo "Please run \`apt-get install -y libasound2-dev\`"
            exit 1
          fi
        fi
      fi
      # TODO: add more Linux distros
      ;;
  esac
}

build_release() {
  local arradio_player_release="arradio-player-${ARRADIO_PLAYER_VERSION}.${GOOS}-${GOARCH}"
  case $GOARCH in
    arm) arradio_player_release="arradio-player-${ARRADIO_PLAYER_VERSION}.${GOOS}-armhf" ;;
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
  # Build executable
  echo "==> Building release"
  # -s Will turn off the symbol table, so you won’t be able to use commands like `go tool nm`.
  # -w Turns off the ‘DWARF’ debugging information, so you won’t be able to set breakpoints or get
  # specific information in stacktraces. Likewise, certain profile use cases won’t work, like `pprof`.
  go build -ldflags="-s -w" -o ${arradio_player_release} && echo "${arradio_player_release}"
}

readonly TOP_DIR="$(pwd)"
readonly ARRADIO_PLAYER_VERSION="0.0.1"

set_goos
set_goarch
set_cgo

export TMP_DIR="$HOME/.arradio-player-$GOARCH-$GOOS"

if [ ! -d $TMP_DIR ]; then
  mkdir -p $TMP_DIR
  cd $TMP_DIR
  install_go
  cd -
fi

export PATH="$TMP_DIR/go/bin:$PATH"

go env

check_build_dependencies
build_release

# End of file
