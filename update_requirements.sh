#!/bin/bash
set -eu -o pipefail

. .envrc
export CUSTOM_COMPILE_COMMAND="./update_requirements.sh"
pip-compile --output-file=requirements.txt requirements/*
