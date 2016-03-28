#!/bin/bash
BUILD_DIR=${1:-_book}
git subtree push --prefix "$BUILD_DIR" origin gh-pages
