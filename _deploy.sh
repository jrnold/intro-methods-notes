#!/bin/bash
BUILD_DIR=${1:-_book}
cd $BUILD_DIR
git init
git add .
git commit -m "Travis update"
git push -f "https://${GH_TOKEN}@github.com/${GH_REF}/" master:gh-pages 2>&1 | sed -e "s/${GH_TOKEN}/XXXX/g"
