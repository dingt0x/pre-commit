#!/bin/bash

# ==========================================
# 配置区
# ==========================================
INDENT=4             # 设定缩进为 4 个空格
FILE_PATTERN="\.sh$" # 匹配 .sh 文件
CHECK_CMD="shfmt -i $INDENT -d"
FIX_CMD="shfmt -i $INDENT -w"

# ==========================================
# 逻辑区
# ==========================================

# 1. 获取暂存区文件
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR | grep "$FILE_PATTERN")

if [ -z "$STAGED_FILES" ]; then
    exit 0
fi

# 初始化变量
PASS=true
INVALID_FILES=() # 数组：存放不合规的文件名

# 2. 迭代检查
for FILE in $STAGED_FILES; do
    if ! $CHECK_CMD "$FILE" >/dev/null 2>&1; then
        INVALID_FILES+=("$FILE") # 加入待修复列表
        PASS=false
    fi
done

# 3. 结果汇总输出
if [ "$PASS" = false ]; then
    echo "❌ 发现 ${#INVALID_FILES[@]} 个文件格式不符合规范！"
    echo "--------------------------------------------------"
    echo "📢 请执行以下命令进行一键修复："
    echo ""

    # 核心：将所有不合规文件拼接到修复命令后面，方便用户直接复制
    # 格式如：shfmt -i 4 -w a.sh b.sh c.sh
    echo "    $FIX_CMD ${INVALID_FILES[*]}"

    echo ""
    echo "--------------------------------------------------"
    echo "🚨 提交已拦截，请修复并 git add 后再次尝试。"
    exit 1
fi

echo "✅ 脚本格式检查全部通过！"
exit 0
