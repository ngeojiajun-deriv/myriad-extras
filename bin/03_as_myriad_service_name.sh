#!/bin/bash
# 03_as_myriad_service_name.sh
# Maintainer: jia.jun@deriv.com
# Guess the myriad service name for the given file
bail() {
    echo "$1" >&2;
    exit 1;
}
[ -z "$1" ] && bail "Usage: $(basename $0) <file>";
[ ! -f "$1" ] && bail "File $1 does not exists";
[[ "$1" =~ \.pm$ ]] || echo "The file name does not seems to point to a perl module file" >&2;
# Check weather it is a valid Perl pm file
# The regex for sed is the similar to one provided to the grep but it is lossen
REGEX="^\s*package\s+([a-zA-Z0-9\:]*[a-zA-Z0-9])\s*\;";
PACKAGE_NAME=$(grep -v -E '^#' $1 | head -n 1 | grep --only-matching -E "$REGEX" | sed -E "s/$REGEX/\1/");
(grep -v -E '^#' $1 | grep -m 1 -E "\s*use\s+Myriad::Service\s*" > /dev/null) || bail "Not a myriad service!";
[ -z "$PACKAGE_NAME" ] && bail 'Cannot guess the service name for the file given!';
echo $PACKAGE_NAME | tr '[:upper:]' '[:lower:]' | sed -E 's/::/\./g';
