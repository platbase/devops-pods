#!/bin/bash
set -o errexit

mkdir -p ${CDR_EXT_CACHE}
for ext in "$@"; do
    echo "INSTALL EXT: $ext [ code-server --extensions-dir ${CDR_EXT_CACHE} --install-extension $ext ] ..."
    code-server --extensions-dir ${CDR_EXT_CACHE} --install-extension $ext
done

chown -Rv u01:u01 ${CDR_EXT_CACHE} | (sed -u 7q; echo "..."; tail -n 7)
