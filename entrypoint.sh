#!/usr/bin/env sh

# build server code in services/server/bin/
if [ ! -d "services/server/bin" ]; then
    npm run build-server
fi

# build development client code in dist/
if [ ! -d "dist" ]; then
    npm run build-dev
fi

# start server in debug mode, watching source code changes
npm run watch