#!/bin/bash

PACK_MANIFEST=pack.yml

# Search HEAD diff for a change in the pack version
version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^+version: ')
prev_version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^-version: ')
# Strip version key to get version strings
version=${version_diff#+version: }
prev_version=${prev_version_diff#-version: }

if [ -z "$version" ]; then
    echo "VERSION_BUMPED=false" >> "$GITHUB_ENV"
    echo "No version change detected"
else
    echo "VERSION_BUMPED=true" >> "$GITHUB_ENV"
    echo "PREVIOUS_VERSION=$prev_version" >> "$GITHUB_ENV"
    echo "VERSION=$version" >> "$GITHUB_ENV"
    echo "Detected version change v$prev_version -> v$version"
fi
