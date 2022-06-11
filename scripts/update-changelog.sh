#!/bin/bash

# Moves unreleased section to a new version section

echo "Updating $changelog for v$version:"

echo '  - Resetting unreleased changelog'
sed -ni "1,/$start_regex/ p; /$end_regex/,$ p" $changelog
sed -i "/$start_regex/ {
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
    }" $changelog

echo '  - Adding new version section after unreleased section'
sed -i "/$end_regex/ {
        a
        a ## [$version]
        r $new_changelog
    }" $changelog

echo '  - Adding new version anchor'
sed -i "/^\[Unreleased]/a [$version]: $repo_url/compare/v$previous_version...v$version" $changelog

echo '  - Updating unreleased anchor'
sed -i "s|^\[Unreleased\]: .*|[Unreleased]: $repo_url/compare/v$version...HEAD|" $changelog

echo "v$version changelog:"
echo '---'
cat $new_changelog 
echo '---'
