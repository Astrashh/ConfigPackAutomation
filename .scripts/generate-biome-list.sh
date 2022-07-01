#!/bin/bash

WIKI_PATH='.wiki'
LIST='biome-list.txt'
DOC="$WIKI_PATH/Biome-List.md"

find biomes/*/ -name "*.yml" -not -path "biomes/abstract/*" | sed "s|^biomes/||" > $LIST

touch $DOC

LIST_CONTENTS="$(cat $LIST)"
for path in $LIST_CONTENTS
do
    IFS="/" read -a items <<< $path # Split path into a list
    raw_file_name="${items[-1]}"
    file_name="${raw_file_name%.yml}"
    for (( i=0; i < ${#items[@]}; i++ ))
    do
        items[$i]=$(sed 's/.yml//; s/^./\u&/; s/_\(.\)/ \u\1/g' <<< ${items[$i]}) # Humanize each list item
    done
    biome_name=${items[-1]}
    unset items[-1]
    
    # Generate section
    echo "## $biome_name" >> $DOC
    printf "CATEGORIES - " >> $DOC
    for item in ${items[@]}
    do
        printf "\`$item\` " >> $DOC
    done
   
    printf "\n" >> $DOC

    # Add image to section if it exists
    docs_image="images/$file_name.png"
    image_path="$WIKI_PATH/$docs_image"
    if test -f $image_path; then
        printf "<img src="$docs_image">\n" >> $DOC
    fi
    
    printf "\n" >> $DOC
done
