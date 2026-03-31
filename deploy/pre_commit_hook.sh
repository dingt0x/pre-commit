#!/bin/bash

# 获取所有即将提交的 .sh 文件
STAGED_SH_FILES=$(git diff --cached --name-only --diff-filter=ACMR | grep '\.sh$')

if [ -z "$STAGED_SH_FILES" ]; then
    exit 0
fi

PASS=true

for FILE in $STAGED_SH_FILES; do
    # 使用 shfmt 检查格式 (-d 表示显示差异，如果没差异返回0)
    # 如果你没安装 shfmt，也可以用简单的 grep 检查行尾空格作为 Demo
    if ! shfmt -i 4 -d "$FILE" >/dev/null 2>&1; then
        echo "❌ 错误: 文件 $FILE 未经过格式化 (fmt)！"
        echo "请运行: shfmt -i 4 -w $FILE"
        PASS=false
    fi
done

if [ "$PASS" = false ]; then
    echo "🚨 提交被拒绝！请修复上述格式问题后再试。"
    exit 1
fi

exit 0
