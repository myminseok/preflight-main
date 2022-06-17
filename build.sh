#!/bin/bash
OS=$(uname | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
if [ "$#" -eq 0 ]; then
  echo "provides target preflight project path"
  exit 1
fi
TARGET_PROJECT=$1
if [[ "$OS" == "darwin" ]]; then
  TARGET_PROJECT_PATH=`greadlink -f ${TARGET_PROJECT}`
else
  TARGET_PROJECT_PATH=`readlink -f ${TARGET_PROJECT}`
fi

case $ARCH in
  "x86_64") 
    ARCH="amd64"
    ;;
  "arm64")
    ;;
  "amd64")
    ;;
esac
echo "OS: $OS"
echo "ARCH: $ARCH"

source ~/.gvm/scripts/gvm
gvm use go1.17.1

cd $TARGET_PROJECT_PATH

make build
sudo rm -rf /usr/local/bin/preflight
set -x
sudo ln -s $TARGET_PROJECT_PATH/bin/preflight-$OS-$ARCH /usr/local/bin/preflight

