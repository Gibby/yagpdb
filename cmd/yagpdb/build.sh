#!/bin/bash
VERSION=$(git symbolic-ref -q --short HEAD || git describe --tags --exact-match)
echo Building version $VERSION
go build -ldflags "-X github.com/jonas747/yagpdb/common.VERSION=${VERSION}"
