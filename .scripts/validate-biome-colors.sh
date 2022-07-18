#!/bin/bash
biome_config_paths="$(find biomes/*/ -name "*.yml" -not -path "biomes/abstract/*")"
errors=''
fail=false
for path in $biome_config_paths
do
    config_id_line="$(grep 'id: ' $path)"
    config_id="${config_id_line#id: }"
    color_line="$(grep 'color: ' $path)"
    color_id="${color_line#color: \$biomes/colors.yml:}"
    if ! grep -q '[^[:space:]]' <<< $color_line; then
        fail=true
        errors+="\n$config_id - does not contain a colors key."
    elif [[ $color_id != $config_id ]]; then
        fail=true
        errors+="\n$config_id color '$color_id' does not match biome id."
    fi
done
if [[ $fail == true ]]; then
    echo -e $errors >&2
    exit 1
fi
