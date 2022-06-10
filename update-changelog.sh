#!/bin/bash

# Moves unreleased section to a new version section

changelog=$1
prev_version=$2
version=$3

GITHUB_REPO='https://github.com/PolyhedralDev/TerraOverworldConfig'
# Delimiters used to identify the unreleased changelog section:
START_DELIMITER='UNRELEASED START'
END_DELIMITER='UNRELEASED END'

echo "Updating changelog for v$version:"

# Copy unreleased changelog to temporary file
echo '- Extracting unreleased changelog'
temp_changelog=$(mktemp)
sed "1,/$START_DELIMITER/ d; /$END_DELIMITER/,$ d" $changelog > $temp_changelog

# Remove unused subheadings from new changelog
echo '- Stripping empty titles from changelog'
echo "$(awk '/^$/ {if (i) {b=b $0 "\n"} else {print $0 }; next} \
    /^###/ {i=1; b=$0; next} {if (i) {print b}; i=0; print $0; next}' $temp_changelog)" > $temp_changelog 

if ! grep -q '[^[:space:]]' "$temp_changelog"; then
    echo '  - WARNING: Unreleased changelog is empty!'
fi

echo "- Updating $changelog file:"

echo '  - Resetting unreleased changelog'
sed -ni "1,/$START_DELIMITER/ p; /$END_DELIMITER/,$ p" $changelog
sed -i "/$START_DELIMITER/ {
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
sed -i "/$END_DELIMITER/ {
        a
        a ## [$version]
        r $temp_changelog
    }" $changelog

echo '  - Adding new version anchor'
sed -i "/^\[Unreleased]/a [$version]: $GITHUB_REPO/compare/v$prev_version...v$version" $changelog

echo '  - Updating unreleased anchor'
sed -i "s|^\[Unreleased\]: .*|[Unreleased]: $GITHUB_REPO/compare/v$version...HEAD|" $changelog

echo "v$version changelog:"
echo '---'
cat $temp_changelog 
echo '---'

rm $temp_changelog