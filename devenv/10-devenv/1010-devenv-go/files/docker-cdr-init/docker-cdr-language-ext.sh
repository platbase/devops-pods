#!/bin/bash
set -o errexit

echo ".... Go environment variables(go env):"
echo " .... --------"
su - u01 -c "go env"
echo " .... --------"
