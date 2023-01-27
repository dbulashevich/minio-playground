#!/bin/sh
mc alias set primary http://primary:9000 minioadmin minioadmin > /dev/null

timeout -v 10 "$@"
