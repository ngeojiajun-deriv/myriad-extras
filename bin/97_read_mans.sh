#!/bin/bash
bail() {
    echo "$1" >&2;
    exit 1;
}
which nnn || bail "nnn is missing";
OUTPUT=${1:-~/pod-mans}
VISUAL=less nnn -e $OUTPUT