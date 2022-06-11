#!/bin/bash

# Copy unreleased changelog to temporary file
echo '- Extracting unreleased changelog'
sed "0,/$start_regex/ d; /$end_regex/,$ d" $changelog > $new_changelog

# Remove unused subheadings from new changelog
echo '- Stripping empty titles from changelog'
echo "$(awk '/^$/ {if (i) {b=b $0 "\n"} else {print $0 }; next} \
    /^###/ {i=1; b=$0; next} {if (i) {print b}; i=0; print $0; next}' $new_changelog)" > $new_changelog 

if ! grep -q '[^[:space:]]' "$new_changelog"; then
    echo '  - WARNING: Unreleased changelog is empty!'
fi
