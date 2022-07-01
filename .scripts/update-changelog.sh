#!/bin/bash

# Moves unreleased section to a new version release section, and updates anchors at the bottom of the changelog

echo "Updating $CHANGELOG for v$version:"

echo '- Inserting release changelog'
sed -i "/$START_REGEX/,/$END_REGEX/{//!d}" $CHANGELOG
sed -i "/$START_REGEX/ {
        a ### Added
        a
        a
        a ### Changed
        a
        a
        a ### Removed
        a
        a
        a ### Fixed
        a
        a
        a ## [v$version]
        r $RELEASE_CHANGELOG
        a
    }" $CHANGELOG

echo '- Adding new version anchor'
sed -i "/^\[Unreleased]/a [v$version]: $REPOSITORY_URL/compare/v$previous_version...v$version" $CHANGELOG

echo '- Updating unreleased anchor'
sed -i "s|^\[Unreleased\]: .*|[Unreleased]: $REPOSITORY_URL/compare/v$version...HEAD|" $CHANGELOG

echo "v$version changelog:"
echo '---'
cat $RELEASE_CHANGELOG 
echo '---'
