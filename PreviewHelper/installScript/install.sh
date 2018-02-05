#!/bin/sh

PRODUCT="./PreviewHelper.qlgenerator"
QL_PATH=~/Library/QuickLook/

rm -rf "$QL_PATH/$PRODUCT"
test -d "$QL_PATH" || mkdir -p "$QL_PATH" && cp -R "$PRODUCT" "$QL_PATH"
qlmanage -r

echo "$PRODUCT installed in $QL_PATH Success!" 
