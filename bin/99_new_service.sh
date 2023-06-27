#!/bin/bash
# 99_new_service.sh generate new service
# Usage: 99_new_service.sh
bail() {
    echo "$1" >&2;
    exit 1;
}
expand_path() {
    if [ -d "$1" ]; then
        echo $(bash -c "cd \"$1\" && pwd");
    else
        echo $(bash -c "cd \"$(dirname $1)\" && pwd");
    fi
}
if [ -z "$1" ]; then
    bail "Usage: $0 <service name>";
fi
SERVICE_NAME=$(echo "$1" | grep -E '^([a-zA-Z0-9]|\:\:)*[a-zA-Z0-9]$');
[ -z "$SERVICE_NAME" ] && bail "$1 is not a valid perl package name!"
FILE_NAME=$(echo "$SERVICE_NAME" | sed -E 's/::/\//g' );
# Make the needed dirs
mkdir -p "lib/$(dirname $FILE_NAME)";
# Copy the template and apply the stuffs
sed -E "s/a::b::c/$SERVICE_NAME/g" "$(expand_path $(which $0))/../share/myriad-service-example.sed.pl" \
    > "lib/$FILE_NAME.pm";
