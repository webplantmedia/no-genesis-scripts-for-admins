#!/bin/bash
# set -xv

source ~/.rackspace.bash

src="https://github.com/webplantmedia/creative-pro/archive/master.zip"

token() {
    token=`curl -s "$RACKSPACE_IDENTITY" -X POST \
    -d '{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$RACKSPACE_USERNAME'", "apiKey":"'$RACKSPACE_APIKEY'"}}}' \
    -H "Content-Type: application/json" | python -m json.tool  | sed -n '/expires/{n;p;}' | sed -e 's/^.*"id": "\(.*\)",/\1/'`
    echo "Your API Token is ---->  $token"
}

cdnauth() {
    cdnauth=`curl -s "$RACKSPACE_IDENTITY" -X POST \
    -d '{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username":"'$RACKSPACE_USERNAME'", "apiKey":"'$RACKSPACE_APIKEY'"}}}' \
    -H "Content-Type: application/json" | python -m json.tool | grep https://storage101."$RACKSPACE_DC" | sed -e 's/.*": "\(.*\)",/\1/'`
    url=`echo $cdnauth | sed -e 's/ *$//'`
}

listcontainers()  {
    curl -H "X-Auth-Token: $token" $url  
}

cd .

product="creative-pro"

# grab version number and clean it
version=$(grep "^Version: " ./style.css | cut -f2 -d ":" | tr -d ' ' | tr -d '\n')
echo $version
secretkey=`echo -n "webplantmedia-${product}-${version}" | md5sum | awk '{print $1}'` 
sanitizeversion=$(echo "$version" | tr . -)
local_zip="${product}-${version}.zip"
rackspace_product="${product}-${version}-${secretkey}.zip"

echo "Uploading Theme to Rackspace CloudFiles."

token
cdnauth

curl -i -X PUT -T ./${local_zip} -H "Content-Type: application/zip" -H "X-Auth-Token: $token" "$url/$RACKSPACE_CONTAINER/$rackspace_product"

echo "${WEBPLANTMEDIA_TLD}${rackspace_product}" | pbcopy
echo "${WEBPLANTMEDIA_TLD}${rackspace_product}"
