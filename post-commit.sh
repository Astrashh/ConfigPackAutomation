#!/bin/bash

# Relevant files
CHANGELOG=CHANGELOG.md
PACK_MANIFEST=pack.yml

# Search HEAD diff for a change in the pack version
version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^+version: ')
prev_version_diff=$(git diff HEAD^ HEAD "$PACK_MANIFEST" | grep '^-version: ')
# Strip version key to get version strings
version=${version_diff#+version: }
prev_version=${prev_version_diff#-version: }

if [ -z "$version" ]; then
    echo "No version change detected"
else
    echo "Detected version change v$prev_version -> v$version"
    sh update-changelog.sh $CHANGELOG $prev_version $version
    echo "Committing changelog"
    #git add $CHANGELOG
    #git commit -m "Version $version"
fi
