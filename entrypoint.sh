#!/bin/bash

set -ex

setup-docker &

# call original entrypoint from jenkins/jnlp-slave
exec jenkins-slave "$@"
