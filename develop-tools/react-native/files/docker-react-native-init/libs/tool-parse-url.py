#!/usr/bin/env python

import os
import sys
from urlparse import urlparse

if len(sys.argv) <=1:
    print "Usage:", sys.argv[0], "URL [hostname|port|scheme|netloc|path|query|fragment|username|password]"
else:
    uri = sys.argv[1]
    result = urlparse(uri)

    if len(sys.argv) <=2:
        print result
    else:
        item = sys.argv[2]
        
        xstr = lambda s: s or ""
        
        val = xstr(getattr(result, item))
        
        if ("port"==item) and (""==val) :
            if "http"==result.scheme:
                val = 80
            if "https"==result.scheme:
                val = 443
        
        print val