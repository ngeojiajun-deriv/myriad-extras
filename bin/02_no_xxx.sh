#!/bin/bash
# 02_no_xxx.sh - Ensure no *.pm files contains the XXX imports
bail() {
    echo "$1" >&2;
    exit 1;
}
echo "Collecting *.pm files";
for FILE in $(find . -type f -name '*.pm'); do
    RESULT=$(grep -v -E '^#' $FILE | grep -m 1 -E '\s*use\s+XXX\s*;*' >/dev/null && echo "FAIL");
    echo "$FILE: ${RESULT:-OK}";
    if [ "$RESULT" == "FAIL" ]; then
        bail "$FILE contains reference to XXX";
    fi
done;
echo "Check done";
