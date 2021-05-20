#!/bin/bash

echo "Got arg $1"

if ! command -v uconv; then
    echo "Please install the uconv command"
    exit 1
else
    echo "Got the uconv command"
    echo "Available transliterators are:"
    uconv -L
fi
