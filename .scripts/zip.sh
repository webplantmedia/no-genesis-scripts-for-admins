#!/bin/bash
# set -xv

cd .

product="creative-pro"

# remove any previous zip file.
rm ${product}*.zip

# grab version number and clean it
version=$(grep "^Version: " ./style.css | cut -f2 -d ":" | tr -d ' ' | tr -d '\n')
sanitizeversion=$(echo "$version" | tr . -)

# change name and zip
git archive -o ${product}-${version}.zip --prefix=${product}/ HEAD 

echo "Zipped: ${product}-${version}.zip"
