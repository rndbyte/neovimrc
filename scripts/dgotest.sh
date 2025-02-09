#!/bin/bash

containerName=$1
argsInput=${@:2}

args=("${args//(*}")

# Detect path
container=$(docker ps -n=-1 --filter name=$containerName --format="{{.ID}}")
execPath=$(docker exec -it $container /bin/bash -c "if [ -f /bin/sh ]; then echo /bin/sh; else echo /bin/bash; fi" | tr -d '\r')

# Run the tests
docker exec -it $container $execPath -c "${args}"
