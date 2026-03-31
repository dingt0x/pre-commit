#!/bin/bash

INDENT=4
FILE_PATTERN="\.sh$"
CHECK_CMD="shfmt -i $INDENT -d"
FIX_CMD="shfmt -i $INDENT -w"

MODE=${1:-"pre_commit"}

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR | grep "$FILE_PATTERN")

if [ -z "$STAGED_FILES" ]; then
    exit 0
fi

PASS=true
INVALID_FILES=()

for FILE in $STAGED_FILES; do
    if ! $CHECK_CMD "$FILE" >/dev/null 2>&1; then
        INVALID_FILES+=("$FILE")
        PASS=false
    fi
done

case "$MODE" in
"pre_commit")
    if [ "$PASS" = false ]; then
        echo "❌ 发现 ${#INVALID_FILES[@]} 个文件格式不符合规范！"
        echo "--------------------------------------------------"
        echo "📢 请执行make fmt或以下命令进行一键修复："
        echo ""
        echo "    $FIX_CMD ${INVALID_FILES[*]}"
        echo ""
        echo "--------------------------------------------------"
        echo "🚨 提交已拦截，请修复并 git add 后再次尝试。"
        exit 1
    fi
    echo "✅ 脚本格式检查全部通过！"
    exit 0
    ;;
"fmt")
    if [ "$PASS" = false ]; then
        echo $FIX_CMD ${INVALID_FILES[*]}
        $FIX_CMD ${INVALID_FILES[*]}
        echo "✅ 脚本格式化完成！"
    else
        echo "所有文件都符合规范，无需格式化"
    fi
    ;;
"*")
    echo "Usage: $0 {pre_commit|fmt}"
    exit 1
    ;;
esac
