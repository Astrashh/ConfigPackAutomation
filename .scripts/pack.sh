#!/bin/bash

# Sets up the files to be included in the release

mkdir .artifacts
zip -r "./.artifacts/$PACK_ARTIFACT_NAME.zip" *
