#!/bin/bash

mkdir .docs
LIST='biome-list.txt'
DOC='.docs/biome-list.md'

find biomes/*/ -name "*.yml" -not -path "biomes/abstract/*" | sed "s|^biomes/||" > $LIST

rm $DOC
touch $DOC
echo '# Biome List' >> $DOC
echo '' >> $DOC

LIST_CONTENTS="$(cat $LIST)"
for path in $LIST_CONTENTS
do
    IFS="/" read -a items <<< $path # Split path into a list
    file_name="${items[-1]}"
    for (( i=0; i < ${#items[@]}; i++ ))
    do
        items[$i]=$(sed 's/.yml//; s/^./\u&/; s/_\(.\)/ \u\1/g' <<< ${items[$i]}) # Humanize each list item
    done
    biome_name=${items[-1]}
    unset items[-1]
    echo "- $biome_name" >> $DOC
done
