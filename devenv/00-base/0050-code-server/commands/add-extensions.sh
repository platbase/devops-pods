#!/bin/bash
set -o errexit

for ext in "$@"; do
    code-server --extensions-dir /usr/local/share/code-server/extensions --install-extension $ext
done

chown -Rv u01:u01 /usr/local/share/code-server/extensions | (sed -u 7q; echo "..."; tail -n 7)
