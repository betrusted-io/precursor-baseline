#!/bin/bash

# argument 1 is the target for copy

if [ -z "$1" ]
then
    echo "Usage: $0 ssh-target [privatekey]"
    echo "Missing ssh-target argument."
    echo "Assumes betrusted-scripts repo is cloned on ssh-target at ~/code/betrused-scripts/"
    exit 0
fi

DESTDIR=code/precursors

# case of no private key specified
if [ -z "$2" ]
then
scp build/gateware/__main__.bin $1:$DESTDIR/encrypted.bin && scp build/csr.csv $1:$DESTDIR/soc-csr.csv
else
# there is a private key
scp -i $2 build/gateware/__main__.bin $1:$DESTDIR/encrypted.bin && scp -i $2 build/csr.csv $1:$DESTDIR/soc-csr.csv
fi

