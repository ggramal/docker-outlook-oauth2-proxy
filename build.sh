#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "working dir $DIR"

mkdir -p $DIR/build
sed -i '5iignored = ["github.com/bitly/oauth2_proxy/*"]' Gopkg.toml
dep ensure || exit 1

pushd vendor/github.com/bitly/
git clone https://github.com/ggramal/oauth2_proxy.git
popd

os=$(go env GOOS)
arch=$(go env GOARCH)
version=$(cat $DIR/version.go | grep "const VERSION" | awk '{print $NF}' | sed 's/"//g')
goversion=$(go version | awk '{print $3}')
sha256sum=()

for os in linux; do
    echo "... building v$version for $os/$arch"
    EXT=
    if [ $os = windows ]; then
        EXT=".exe"
    fi
    BUILD=$(mktemp -d ${TMPDIR:-/tmp}/oauth2_proxy.XXXXXX)
    TARGET="oauth2_proxy-$version.$os-$arch.$goversion"
    FILENAME="oauth2_proxy-$version.$os-$arch$EXT"
    GOOS=$os GOARCH=$arch CGO_ENABLED=0 \
        go build -ldflags="-s -w" -o $BUILD/$TARGET/$FILENAME || exit 1
    pushd $BUILD/$TARGET
    sha256sum+=("$(shasum -a 256 $FILENAME || exit 1)")
    mv $FILENAME $DIR/build
    popd
    cd $DIR/build/ && ln -s $FILENAME oauth2_proxy
done

checksum_file="sha256sum.txt"
cd $DIR/build
if [ -f $checksum_file ]; then
    rm $checksum_file
fi
touch $checksum_file
for checksum in "${sha256sum[@]}"; do
    echo "$checksum" >> $checksum_file
done
