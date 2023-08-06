#!/bin/bash

set -e

BUILD_ROOT="/tmp/build"
OUTPUT_ROOT="/mnt"

VERSION=$(git log --pretty=format:'Date: %cd, Revision: %h' 2>/dev/null || echo "latest" | head -1)

rm -rf ${BUILD_ROOT:?} || :
mkdir -p ${BUILD_ROOT:?} || :

mkdocs build --clean -d ${BUILD_ROOT:?}

INDEXES=$(ls ${BUILD_ROOT:?}/*/index.html | sort -n)

/usr/local/bin/pptrhtmltopdf --no-sandbox \
    --debug \
    --output=draft.pdf \
    --generate-toc \
    ${BUILD_ROOT:?}/index.html \
    ${INDEXES:?}

cp -a draft.pdf ${OUTPUT_ROOT:?}/. || :

rm -f draft-html.zip || :
zip -9r draft-html.zip ${BUILD_ROOT:?}
cp -a draft-html.zip ${OUTPUT_ROOT:?}/. || :

echo ""
echo "pwd"
pwd
ls -al

echo ""
echo "BUILD_ROOT=${BUILD_ROOT:?}"
ls -al ${BUILD_ROOT:?}

echo ""
echo "OUTPUT_ROOT=${OUTPUT_ROOT:?}"
ls -al ${OUTPUT_ROOT:?}
