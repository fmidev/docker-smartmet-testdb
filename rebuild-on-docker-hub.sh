#!/bin/sh 

set -ex
# Force rebuild on docker hub
curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/fmidev/smartmet-testdb/trigger/5b59391e-e4ac-43e1-8328-3af5acd85b68/
echo
