#!/bin/sh

# clean up previous builds
docker rm wikispeech-symbolset
docker rmi wikispeech-symbolset

# build docker
~/opt/blubber symbolset.yaml production | docker build --tag wikispeech-symbolset --file - .
