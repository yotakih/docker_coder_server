#!/bin/sh

cd `dirname $0`
docker-compose up -d > run.log 2>&1

