#!/bin/bash

set -e

BASE_DIR=$(cd "$(dirname "$0")"; pwd)
cd $BASE_DIR
PROJECT_PATH=$(git rev-parse --show-toplevel)
cd $PROJECT_PATH
echo "current project path: $PROJECT_PATH"
PROJECT_NAME="quickjs"
echo "project name: $PROJECT_NAME"

export DEVECO_SDK_HOME="/Applications/DevEco-Studio.app/Contents/sdk"
DEVECO_TOOLS_HOME="/Applications/DevEco-Studio.app/Contents/tools"
DEVECO_OHPM="${DEVECO_TOOLS_HOME}/ohpm/bin"
DEVECO_HVIGOR="${DEVECO_TOOLS_HOME}/hvigor/bin"
DEVECO_NODE="${DEVECO_TOOLS_HOME}/node/bin"
export PATH="${DEVECO_OHPM}:${DEVECO_HVIGOR}:${DEVECO_NODE}:$PATH"

rm -rf $PROJECT_PATH/oh_modules
rm -rf $PROJECT_PATH/build
rm -rf $PROJECT_PATH/$PROJECT_NAME/.cxx
rm -rf $PROJECT_PATH/$PROJECT_NAME/oh_modules
rm -rf $PROJECT_PATH/$PROJECT_NAME/build

ohpm config set registry https://ohpm.openharmony.cn/ohpm/
ohpm config set strict_ssl false
ohpm clean
ohpm install --registry https://ohpm.openharmony.cn/ohpm/ --strict_ssl false --all

hvigorw -p product=default clean --no-daemon
hvigorw --mode module \
  -p product=default \
  -p module=$PROJECT_NAME@default \
  -p buildMode=release \
  -p debuggable=false \
  assembleHar \
  --no-daemon

har_path="$PROJECT_PATH/$PROJECT_NAME/build/default/outputs/default/$PROJECT_NAME.har"
echo "har path: $har_path"
# ohpm publish $har_path