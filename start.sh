#!/usr/bin/env bash

# downloads all repos and creates a gource viz of all of them together

set -e
set -u

# query github for repos
./query-repos.sh

# git clone or update repos
./download-repos.sh

# build a single event log from all repos
./build-log.sh

# gource
./render-viz.sh
