#!/bin/bash
set -o errexit

# link pre-installed extensions
for file in $(ls /usr/local/share/code-server/extensions/); do
    if [ ! -d "/data/home/.local/share/code-server/extensions/$file" ]; then
        ln -s "/usr/local/share/code-server/extensions/$file" "/data/home/.local/share/code-server/extensions/$file"
    fi
done
