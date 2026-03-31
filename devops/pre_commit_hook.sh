#!/bin/bash

INDENT=4
FILE_PATTERN="\.sh$"
CHECK_CMD="shfmt -i $INDENT -d"
FIX_CMD="shfmt -i $INDENT -w"

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

if [ "$PASS" = false ]; then
    echo "❌ 发现 ${#INVALID_FILES[@]} 个文件格式不符合规范！"
    echo "--------------------------------------------------"
    echo "📢 请执行以下命令进行一键修复："
    echo ""
    echo "    $FIX_CMD ${INVALID_FILES[*]}"
    echo ""
    echo "--------------------------------------------------"
    echo "🚨 提交已拦截，请修复并 git add 后再次尝试。"
    exit 1
fi

echo "✅ 脚本格式检查全部通过！"
exit 0
