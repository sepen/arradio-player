#!/bin/bash -e

# Init
[ ! -f go.mod ] && go mod init arradio-player

# Deps
go mod tidy

# Debug
go run arradio-player || echo "Exit $?"

# Build executable
go build
