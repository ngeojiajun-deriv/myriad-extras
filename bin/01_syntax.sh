#!/bin/bash
# 01_syntax.sh
# Maintainer: jia.jun@deriv.com
# Run perl -cw on given directory and catch for errors
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
DIR=${1:-$(pwd)};
OVERIDDEN_IMAGE_NAME=$2;

if [ $DIR == '--exec-inner' ]; then
    # Inner suite
    for FILE in $(find . -type f -name '*.pm'); do
        perl -cw -I/app/lib -MMyriad $FILE || bail "Check failed for the file $FILE";
    done
    exit 0;
else
    echo "Starting test suite in $DIR";
    if [ ! -d "$DIR/lib/" ]; then
        bail  "Cannot find $DIR/lib/, exitting";
    fi
    which docker > /dev/null || bail "cannot find docker! Exitting";

    IMAGE_NAME='deriv/myriad:latest';

    # Rebuild the image if there is a Dockerfile there
    if [ -f "$DIR/Dockerfile" ]; then
        IMAGE_NAME=$(mktemp -u ci/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | tr '[:upper:]' '[:lower:]');
        IMAGE_NAME=${OVERIDDEN_IMAGE_NAME:-$IMAGE_NAME};
        echo "Dockerfile present, building it as $IMAGE_NAME";
        docker build  "$DIR" -t $IMAGE_NAME || bail "Cannot build image! Exitting";
    fi
    
    # Create the image and actually run it
    docker run --rm -v $(expand_path $DIR):/app/ -v $(expand_path $(which $0)):/ci-tools  --entrypoint /bin/bash $IMAGE_NAME -c \
            'cd /app && /ci-tools/01_syntax.sh --exec-inner' 
    RET=$?
    # Cleanup if it is auto regenerated
    [ -f "$DIR/Dockerfile" ] && [ "$IMAGE_NAME" != "$OVERIDDEN_IMAGE_NAME" ] && docker image rm $IMAGE_NAME;
    exit $RET;
fi
