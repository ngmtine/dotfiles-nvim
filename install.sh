#!/bin/bash
# このdotfiles-nvimリポジトリのnvimディレクトリを~/.config/nvimにシンボリックリンクするためのスクリプト

# エラーが発生したらスクリプトを終了する
set -eu

# このスクリプトが存在するディレクトリの絶対パスを取得
REPO_ROOT=$(cd "$(dirname "$0")" && pwd)

# シンボリックリンクのソースとターゲットを定義
SOURCE_DIR="$REPO_ROOT/nvim"
TARGET_DIR="$HOME/.config"
TARGET_PATH="$TARGET_DIR/nvim"

echo "Neovim configuration installer"
echo "--------------------------------"
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_PATH"
echo ""

# ターゲットの親ディレクトリが存在しない場合は作成
mkdir -p "$TARGET_DIR"

# ターゲットパスに既存の設定があるかチェック
if [ -e "$TARGET_PATH" ]; then
    # それがこのリポジトリへのシンボリックリンクでない場合のみバックアップを作成
    if [ ! -L "$TARGET_PATH" ] || [ "$(readlink "$TARGET_PATH")" != "$SOURCE_DIR" ]; then
        BACKUP_PATH="${TARGET_PATH}.bak.$(date +%Y%m%d-%H%M%S)"
        echo "Existing configuration found at $TARGET_PATH."
        echo "Backing it up to $BACKUP_PATH"
        mv "$TARGET_PATH" "$BACKUP_PATH"
    else
        echo "Symlink already exists and is correct. Nothing to do."
        exit 0
    fi
fi

# シンボリックリンクを作成
echo "Creating symlink..."
ln -snfv "$SOURCE_DIR" "$TARGET_PATH"

echo ""
echo "✅ Installation complete!"
echo "You can now run 'nvim' from anywhere to use this configuration."
