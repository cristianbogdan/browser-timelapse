#!/bin/bash

#start cron
service cron start

cleanup()
{
    echo "Caught Signal ... cleaning up."
    service cron stop
    echo "Done cleanup ... quitting."
    exit 0
}

trap cleanup INT TERM

#make sure the container stays busy so it does not exit
coproc read  && wait "$!" || true

