#!/bin/bash

set -ex

setup-docker &

# call original entrypoint from jenkins/jnlp-slave

exec gosu jenkins /usr/local/bin/jenkins-slave "$@"
