#!/bin/bash
set -e

rm -fR README.md .devcontainer .git
read GITLAB_URL <<< 'Enter your gitlab repo'