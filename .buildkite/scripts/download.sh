#!/bin/bash

set -euo pipefail

BK_REGISTRY_SLUG=autopkg

BK_PACKAGE_URL=https://packages.buildkite.com/$BUILDKITE_ORGANIZATION_SLUG/$BK_REGISTRY_SLUG

buildkite_api_token=$(buildkite-agent oidc request-token --audience "$BK_PACKAGE_URL" --lifetime 300)

echo "--- Listing packages in $BK_REGISTRY_SLUG"

latest_version_url=$(curl -sS -H "Authorization: Bearer $buildkite_api_token" -X GET "https://api.buildkite.com/v2/packages/organizations/$BUILDKITE_ORGANIZATION_SLUG/registries/$BK_REGISTRY_SLUG/packages" | jq -r '.items[-1].url')

if [ -z "$latest_version_url" ]; then
    echo "Error: Failed to extract URL from package list JSON"
    exit 1
fi

echo "--- Downloading package info from: $latest_version_url"

filename=$(curl -sS -H "Authorization: Bearer $buildkite_api_token" -X GET $latest_version_url | jq -r .name)

download_url="https://packages.buildkite.com/$BUILDKITE_ORGANIZATION_SLUG/$BK_REGISTRY_SLUG/files/$filename"

echo "--- Downloading package file from: $download_url"

curl -sS -L -H "Authorization: Bearer $buildkite_api_token" -X GET $download_url -o /tmp/autopkg_metadata.json

cat /tmp/autopkg_metadata.json