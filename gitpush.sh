#!/bin/bash

[ $# -gt 0 ] && {
  commitInfo=$1
} || {
  commitInfo="update"
}

git pull
git add .
git commit -m $commitInfo
git push origin main
git log | head -n 20
echo -e "https://github.com/ssbandjl/it"
