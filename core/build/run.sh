#!/bin/sh

# Bail out if any command fails.
set -e -o pipefail

# Treat all arguments as an individual command to be evaluated by a shell.
for cmd in "$@"; do
  sh -c "${cmd}"
done
