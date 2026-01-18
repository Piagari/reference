#!/bin/bash

# 删除 .DS_Store 文件的脚本
# 使用方法: ./cleanup_ds_store.sh

echo "正在删除 .DS_Store 文件..."

# 删除所有 .DS_Store 文件
find . -name ".DS_Store" -type f -delete

# 从 git 中删除已跟踪的 .DS_Store 文件
git rm -r --cached --ignore-unmatch .DS_Store
git rm -r --cached --ignore-unmatch "*/.DS_Store"

echo "已删除所有 .DS_Store 文件"

# 检查是否有变更需要提交
if git status --porcelain | grep -q .; then
    echo "发现变更，是否提交? (y/n)"
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        git add .
        git commit -m "删除所有 .DS_Store 文件"
        echo "已提交变更"
    fi
else
    echo "没有变更需要提交"
fi

echo "清理完成!"