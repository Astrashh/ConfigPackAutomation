#!/bin/bash

# Search HEAD diff for a change in the pack version
PACK_MANIFEST=pack.yml
version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^+version: ')
prev_version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^-version: ')
# Strip version key to get version strings
version=${version_diff#+version: }
prev_version=${prev_version_diff#-version: }

if [ -z "$version" ]; then
    echo "::set-output name=version-bumped::false"
    echo "No version change detected"
else
    echo "::set-output name=version-bumped::true"
    echo "::set-output name=previous-version::$prev_version"
    echo "::set-output name=version::$version"
    echo "Detected version change v$prev_version -> v$version"
fi
