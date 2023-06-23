#!/bin/bash
# 98_build_man_for_everything.sh - Generate man pages for all files in current directory
bail() {
    echo "$1" >&2;
    exit 1;
}
which pod2man || bail "pod2man is missing";
which nroff || bail "nroff is missing";
OUTPUT=${1:-~/pod-mans}
echo "Collecting *.pm files";
echo "OUTPUT=$OUTPUT";
mkdir -p $OUTPUT;
for FILE in $(find . -type f -name '*.pm'); do
    echo "Building $FILE"
    mkdir -p "$OUTPUT/$(dirname $FILE)"
    pod2man --errors pod $FILE | nroff -man > "$OUTPUT/$(echo $FILE | sed -E s/\.pm$/\.1/)";
done;
echo "Build done";
