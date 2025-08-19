#!/bin/bash

# このスクリプトが存在するディレクトリの絶対パスを取得
REPO_ROOT=$(cd "$(dirname "$0")" && pwd)
SCRIPT_DIR="$REPO_ROOT/var"

# 諸々をこのスクリプトが存在するディレクトリ以下に指定
export XDG_CONFIG_HOME="$REPO_ROOT"
export XDG_DATA_HOME="$SCRIPT_DIR/.data"
export XDG_STATE_HOME="$SCRIPT_DIR/.state"
export XDG_CACHE_HOME="$SCRIPT_DIR/.cache"

# 起動
NVIM=$(which nvim)
exec "$NVIM" "$@"
