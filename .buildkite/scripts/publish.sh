#!/bin/bash

BK_REGISTRY_SLUG=autopkg
BK_PACKAGE_URL=https://packages.buildkite.com/$BUILDKITE_ORGANIZATION_SLUG/$BK_REGISTRY_SLUG

timestamp=$(date +%s)

set -euo pipefail

## BUILD THE OUPTUT FILE
echo "--- Building autopkg_metadata.json"

echo "{\"build\": \"$BUILDKITE_BUILD_NUMBER\"}" > /tmp/autopkg_metadata.json

buildkite_api_token=$(buildkite-agent oidc request-token --audience "$BK_PACKAGE_URL" --lifetime 300)

echo "--- Upload autopkg_metadata-$timestamp.json to $BK_REGISTRY_SLUG"

cat /tmp/autopkg_metadata.json | curl -sS -H "Authorization: Bearer $buildkite_api_token" \
    -X POST "https://api.buildkite.com/v2/packages/organizations/$BUILDKITE_ORGANIZATION_SLUG/registries/$BK_REGISTRY_SLUG/packages" \
    -F "file=@-;filename=autopkg_metadata-$timestamp.json"

cat /tmp/autopkg_metadata.json