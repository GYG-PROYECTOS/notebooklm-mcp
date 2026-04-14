#!/bin/sh
# Wrapper to transform --remote-debugging-pipe to --remote-debugging-port=9222
# This is needed because patchright uses --remote-debugging-pipe which crashes
# on Debian's Chromium package, but --remote-debugging-port works fine.

args=""
for arg in "$@"; do
    if [ "$arg" = "--remote-debugging-pipe" ]; then
        # Replace pipe with WebSocket-based debugging on port 9222
        args="$args --remote-debugging-port=9222"
    else
        args="$args $arg"
    fi
done

# Use the actual Chromium binary from the Debian package
exec /usr/lib/chromium/chromium $args
