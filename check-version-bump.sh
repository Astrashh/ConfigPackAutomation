#!/bin/bash

# Search HEAD diff for a change in the pack version
PACK_MANIFEST=pack.yml
version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^+version: ')
previous_version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^-version: ')
# Strip version key to get version strings
version=${version_diff#+version: }
previous_version=${previous_version_diff#-version: }

if [ -z "$version" ]; then
    echo "No version change detected"
    echo "version-bumped=false" >> "$GITHUB_ENV"
else
    echo "Detected version change v$prev_version -> v$version"
    echo "version-bumped=true" >> "$GITHUB_ENV"
    echo "previous_version=$previous_version" >> "$GITHUB_ENV"
    echo "version=$version" >> "$GITHUB_ENV"
fi
