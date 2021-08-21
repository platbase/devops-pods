#!/bin/bash
set -o errexit

# move to local: pre-installed extensions
for file in $(ls /usr/local/share/code-server/extensions/); do
    if [ ! -d "/data/home/.local/share/code-server/extensions/$file" ]; then
    	echo "... Prepare extension :'/data/home/.local/share/code-server/extensions/$file' ..."
        mv "/usr/local/share/code-server/extensions/$file" "/data/home/.local/share/code-server/extensions/$file"
    fi
done
