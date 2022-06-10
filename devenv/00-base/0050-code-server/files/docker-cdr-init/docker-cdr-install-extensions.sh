#!/bin/bash
set -o errexit

# move to local: pre-installed extensions
if [ -d "${VSC_EXT_CACHE}/" ]; then
	for file in $(ls ${VSC_EXT_CACHE}/); do
	    if [ ! -d "/data/home/.local/share/code-server/extensions/$file" ]; then
	    	echo "... Prepare extension :'/data/home/.local/share/code-server/extensions/$file' ..."
	        mv "${VSC_EXT_CACHE}/$file" "/data/home/.local/share/code-server/extensions/$file"
	    fi
	done
fi
