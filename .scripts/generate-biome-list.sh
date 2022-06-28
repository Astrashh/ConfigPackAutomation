#!/bin/bash

mkdir .docs
find biomes -name "*.yml" -not -path "biomes/abstract/*" > .docs/biome-list.txt
