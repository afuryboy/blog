#!/usr/bin/env bash

echo "deploy start..."
git add .
git commit -m $1
echo "git提交注释:$1"
git push origin master
echo "deploy end..."