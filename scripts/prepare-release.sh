#!/bin/bash

BIN_DIR="./dist/bin/"
RELEASE_DIR="./dist/release/"

mkdir -p $RELEASE_DIR

# if this is run on travis make sure that binary was build with corrent version
if [[ -n $TRAVIS_TAG ]]; then
    echo "Checking if ocdev version was set to the same version as current tag"
    # use sed to get only semver part
    bin_version=$(${BIN_DIR}/linux-amd64/ocdev version | sed 's/ .*//g')
    if [ "$TRAVIS_TAG" == "v${bin_version}" ]; then
        echo "OK: ocdev version output is matching current tag"
    else
        echo "ERR: TRAVIS_TAG ($TRAVIS_TAG) is not matching 'ocdev version' (v${bin_version})"
        exit 1
    fi
fi

for arch in `ls -1 $BIN_DIR/`;do
    suffix=""
    if [[ $arch == windows-* ]]; then
        suffix=".exe"
    fi
    gzip --keep --to-stdout $BIN_DIR/$arch/ocdev$suffix > $RELEASE_DIR/ocdev-$arch$suffix.gz
done
