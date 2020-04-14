#!/usr/bin/env bash

commitmsg=$1
if [ -n "$commitmsg" ]; then
   echo "deploy start..."
   git add -A
   git commit -m"${commitmsg}"
   git pull
   git status
   git push origin master
   echo "deploy push success"
else
   echo "请添加注释,再重新点击Deploy按钮"
fi
